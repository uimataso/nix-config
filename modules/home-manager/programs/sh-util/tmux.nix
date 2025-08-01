{
  config,
  lib,
  pkgs,
  ...
}:
# https://man.archlinux.org/man/tmux.1
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.programs.sh-util.tmux;

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
          current_session="$([ -n "''${TMUX+x}" ] && tmux display-message -p -F'#{client_session}' 2>/dev/null)"

          # Get tmux sessions that sort by last attached time
          ( tmux list-sessions -F'#{session_name}:#{session_last_attached}' 2>/dev/null || true ) | sort -r -t':' -k2 | cut -d: -f1 | grep -v "^$current_session$"

          # Get tmux sessions
          tmp="$(mktemp -t tmux-select-sessions.XXXXXXXX)"
          ( tmux list-sessions -F '#{session_name}' 2>/dev/null || true ) | sort > "$tmp"

          # Get tmuxinator project that are not created
          printf '\e[38;5;242m'
          tmuxinator list -n | tail -n+2 | sort | comm "$tmp" - -13
          printf '\e[0m'

          # Get dir in src/* that are not created
          printf '\e[38;5;242m'
          find "$HOME/src/" -mindepth 1 -maxdepth 1 -type d -printf 'src/%P\n' | sort | comm "$tmp" - -13
          printf '\e[0m'

          rm "$tmp"
        }

        selected=$(sessions_list | fzf --height 100% --bind=enter:replace-query+print-query --ansi || true)

        [ -z "$selected" ] && exit

        if ( tmux list-sessions 2>/dev/null || true ) | cut -d: -f1 | grep -x "$selected" >/dev/null; then
          if [ -z "''${TMUX+x}" ]; then
            tmux attach-session -t "$selected"
          else
            tmux switch-client -t "$selected"
          fi
        elif tmuxinator list -n | tail -n+2 | grep -x "$selected" >/dev/null ;then
          tmuxinator start "$selected"
        elif [ -d "$HOME/$selected" ]; then
          if [ -z "''${TMUX+x}" ]; then
            tmux new-session -s "$selected" -c "$HOME/$selected"
          else
            tmux new-session -d -s "$selected" -c "$HOME/$selected"
            tmux switch-client -t "$selected"
          fi
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
in
{
  options.uimaConfig.programs.sh-util.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".config/tmuxinator" ];
    };

    home.shellAliases = {
      t = "tmux";
      ta = "tmux attach-session || tmux new-session -s default";
      ts = "${tmux-select-sessions}/bin/tmux-select-sessions";
      tn = ''name="$(tmux list-sessions -F'#{session_name}:#{session_last_attached}' | sort -r -t':' -k2 | cut -d: -f1 | fzf)"; test -n "$name" && tmux new -t $name'';
      td = "tmuxinator start default";
    };

    programs.nushell.shellAliases = {
      # ta = mkForce "try { tmux attach-session } catch { tmux new-session -s default }";
      ta = mkForce ''bash -c "tmux attach-session || tmux new-session -s default"'';
    };

    stylix.targets.tmux.enable = false;

    programs.tmux = {
      enable = true;

      prefix = "M-b";

      escapeTime = 10;
      baseIndex = 1;
      mouse = true;
      # disableConfirmationPrompt = true;
      shell = config.uimaConfig.sh.executable;

      extraConfig =
        with config.lib.stylix.colors.withHashtag;
        # tmux
        ''
          set -g default-terminal 'tmux-256color'

          # true colors
          set -as terminal-overrides ",xterm-256color:Tc"

          # color on underline and undercurl
          # ref: https://evantravers.com/articles/2021/02/05/curly-underlines-in-kitty-tmux-neovim/
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

          # underscore colours - needs tmux-3.0 (wsl2 in Windows Terminal)}
          # ref: https://github.com/leonasdev/.dotfiles/issues/15#issuecomment-1931906339
          if-shell 'test -n "$WSL_DISTRO_NAME"' {
            set -as terminal-overrides ',*:Setulc=\E[58::2::::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
          }

          set -g history-limit 10000
          set -g mode-keys vi
          set -g status-keys emacs
          set -g set-clipboard external

          # keybind to reload config
          bind r source-file ${config.xdg.configHome}/tmux/tmux.conf

          bind f run-shell 'tmux popup -E "${tmux-select-sessions}/bin/tmux-select-sessions"'
          bind BSpace last-window

          # TODO: control flow: if has lazygit
          bind g new-window -S -n "lazygit" -c "#{pane_current_path}" "lazygit"

          # disable mouse scroll on statusbar
          unbind -T root WheelUpStatus
          unbind -T root WheelDownStatus

          # hjkl to switch
          bind -r h previous-window
          bind -r j select-pane -t :.+
          bind -r k select-pane -t :.-
          bind -r l next-window
          bind -n 'M-h' previous-window
          bind -n 'M-j' select-pane -t :.+
          bind -n 'M-k' select-pane -t :.-
          bind -n 'M-l' next-window

          # resize pane
          bind -n 'M-H' resize-pane -L 3
          bind -n 'M-J' resize-pane -D 3
          bind -n 'M-K' resize-pane -U 3
          bind -n 'M-L' resize-pane -R 3

          # split in same dir
          bind '"' split-window -v -c "#{pane_current_path}"
          bind  %  split-window -h -c "#{pane_current_path}"
          bind  |  split-window -h -c "#{pane_current_path}"

          # create window in same dir
          bind c new-window -c "#{pane_current_path}"

          # better keybind in copy mode
          bind -T copy-mode-vi v   send-keys -X begin-selection
          bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

          set -g repeat-time 200

          # status
          set -g status-justify left
          set -g status-left " #{?client_prefix,#[fg=black bg=white bright] [#S] #[fg=default bg=default],#[bright] [#S] #[]} "
          set -g status-left-length 40
          set -g status-right "#[bright]#(whoami):#h  "
          setw -g window-status-current-format '-#I:#W- '
          setw -g window-status-format '#[fg=${base04}]#I:#W #[fg=default]'

          set -g status-style          fg='${base04}',bg=default
          set -g message-style         bg=black
          set -g message-command-style bg=black
          set -g mode-style            fg=black,bg=green

          # pane border colors
          set -g pane-border-style        fg='${base01}'
          set -g pane-active-border-style fg=white
          set -g popup-border-style       fg='${base01}'

          # window title colors
          set -g window-status-current-style fg=white,bg=default,bold
          set -g window-status-style         fg=brightwhite,bg=default
        '';

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.tmux-nvim;
          extraConfig =
            # tmux
            ''
              set -g @tmux-nvim-navigation false
              set -g @tmux-nvim-resize false

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
  };
}
