{
  config,
  lib,
  pkgs,
  ...
}:
# https://man.archlinux.org/man/tmux.1
with lib;
let
  cfg = config.uimaConfig.sh-util.tmux;

  setEnvVar =
    {
      pkg,
      binPath,
      name,
      val,
    }:
    pkg.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];
      postInstall =
        old.postInstall or ""
        + ''
          wrapProgram "$out/${binPath}" --set ${name} ${val}
        '';
    });

  scheme = config.stylix.base16Scheme;

  tmux-select-sessions-src =
    { writeShellApplication, pkgs }:
    writeShellApplication {
      name = "tmux-select-sessions";
      runtimeInputs = with pkgs; [
        fzf
        tmux
        tmuxinator
      ];
      text = ''
        sessions_list() {
          # Get tmux sessions that sort by created time (i actually want last visit time...)
          ( tmux list-sessions 2>/dev/null || true ) | sort -t' ' -k3 | cut -d: -f1

          # Get tmux sessions

          tmp="$(mktemp)"
          ( tmux list-sessions -F '#{session_name}' 2>/dev/null || true ) | sort > "$tmp"

          # Get tmuxinator project that are not created
          printf '\e[38;5;242m'
          tmuxinator list -n | tail -n+2 | sort | comm "$tmp" - -13
          printf '\e[0m'

          rm "$tmp"
        }

        selected=$(sessions_list | fzf --bind=enter:replace-query+print-query --ansi || true)

        [ -z "$selected" ] && exit

        if ( tmux list-sessions 2>/dev/null || true ) | grep -x "$selected" >/dev/null; then
          if [ -z "''${TMUX+x}" ]; then
            tmux attach-session -t "$selected"
          else
            tmux switch-client -t "$selected"
          fi
        elif tmuxinator list -n | tail -n+2 | grep -x "$selected" >/dev/null ;then
          tmuxinator start "$selected"
        else
          if [ -z "''${TMUX+x}" ]; then
            tmux new-session -s "$selected"
          else
            tmux new-session -d -s "$selected"
            tmux switch-client -t "$selected"
          fi
        fi
      '';
    };
  tmux-select-sessions = pkgs.callPackage tmux-select-sessions-src { };

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.sh-util.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      t = "tmux";
      ta = "tmux attach-session || tmux new-session -s default";
      ts = "${tmux-select-sessions}/bin/tmux-select-sessions";
      td = "tmuxinator start default";
    };

    programs.nushell.shellAliases = {
      # ta = mkForce "try { tmux attach-session } catch { tmux new-session -s default }";
      ta = mkForce ''bash -c "tmux attach-session || tmux new-session -s default"'';
    };

    programs.tmux = {
      enable = true;

      prefix = "M-b";

      escapeTime = 10;
      baseIndex = 1;
      mouse = true;
      # disableConfirmationPrompt = true;
      # TODO: Change shell
      # shell = "${config.programs.nushell.package}/bin/nu";

      extraConfig =
        # tmux
        ''
          set -sa terminal-overrides ",xterm-256color:RGB"

          set -g mode-keys vi
          set -g status-keys emacs
          set -g set-clipboard external

          # keybind to reload config
          bind r source-file ${config.xdg.configHome}/tmux/tmux.conf

          bind f run-shell 'tmux popup -E "${tmux-select-sessions}/bin/tmux-select-sessions"'
          bind BSpace last-window

          # TODO: control flow: if has lazygit
          bind g new-window -S -n "lazygit" -c "#{pane_current_path}" "lazygit"

          # hjkl to switch
          bind -r h previous-window
          bind -r j select-pane -t :.+
          bind -r k select-pane -t :.-
          bind -r l next-window

          # split in same dir
          bind '"' split-window -v -c "#{pane_current_path}"
          bind  %  split-window -h -c "#{pane_current_path}"
          bind  |  split-window -h -c "#{pane_current_path}"

          # create window in smae dir
          bind c new-window -c "#{pane_current_path}"

          # better keybind in copy mode
          bind -T copy-mode-vi v   send-keys -X begin-selection
          bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

          set -g repeat-time 200

          # status
          set -g status-justify left
          set -g status-left " #{?client_prefix,#[fg=black bg=magenta bright] [#S] #[fg=default bg=default],#[bright] [#S] #[]} "
          set -g status-left-length 20
          set -g status-right "#[bright]#(whoami):#h  "
          setw -g window-status-current-format '-#I:#W- '
          setw -g window-status-format '#[fg=#${scheme.base04}]#I:#W #[fg=default]'

          set -g status-style          fg='#${scheme.base04}',bg=default
          set -g message-style         bg=black
          set -g message-command-style bg=black
          set -g mode-style            fg=black,bg=green

          # pane border colors
          set -g pane-border-style        fg='#${scheme.base03}'
          set -g pane-active-border-style fg=magenta
          set -g popup-border-style       fg='#${scheme.base03}'

          # window title colors
          set -g window-status-current-style fg=magenta,bg=default,bold
          set -g window-status-style         fg=brightwhite,bg=default
        '';

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.tmux-nvim;
          extraConfig =
            # tmux
            ''
              set -g @tmux-nvim-resize-step-x 3
              set -g @tmux-nvim-resize-step-y 3
            '';
        }
        tmuxPlugins.tmux-fzf
        tmuxPlugins.fzf-tmux-url
        {
          # prefix enter
          plugin = tmuxPlugins.extrakto;
          extraConfig =
            let
              myFzf = pkgs.writeShellScriptBin "myFzf" ''
                ${pkgs.fzf}/bin/fzf --color=pointer:5,gutter:-1 "$@"
              '';
            in
            # tmux
            ''
              set -g @extrakto_key enter
              set -g @extrakto_fzf_tool "${myFzf}/bin/myFzf"
              set -g @extrakto_fzf_layout reverse
              set -g @extrakto_split_direction p
              set -g @extrakto_popup_size 50%
              set -g @extrakto_fzf_header "f g i c"
            '';
        }
      ];
    };

    programs.tmux.tmuxinator.enable = true;

    home.persistence.main = mkIf imper.enable { directories = [ ".config/tmuxinator" ]; };
  };
}
