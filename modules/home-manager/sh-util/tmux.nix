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
      ];
      text = ''
        selected="$(tmux list-sessions -F "#{session_name}" | fzf || true)"
        test -z "$selected" && exit
        tmux switch-client -t "$selected"
      '';
    };
  tmux-select-sessions = pkgs.callPackage tmux-select-sessions-src { };

  tmuxinator-fzf-src =
    { writeShellApplication, pkgs }:
    writeShellApplication {
      name = "tmuxinator-fzf";
      runtimeInputs = with pkgs; [
        fzf
        tmux
        tmuxinator
      ];
      text = ''
        selected="$(tmuxinator list -n | tail -n +2 | fzf || true)"
        test -z "$selected" && exit
        tmuxinator s "$selected"
      '';
    };
  tmuxinator-fzf = pkgs.callPackage tmuxinator-fzf-src { };

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
      ts = "${tmuxinator-fzf}/bin/tmuxinator-fzf";
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
      terminal = "screen-256color";
      # TODO: other shell
      shell = "${config.programs.nushell.package}/bin/nu";
      baseIndex = 1;
      mouse = true;
      # disableConfirmationPrompt = true;

      extraConfig =
        # tmux
        ''
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
