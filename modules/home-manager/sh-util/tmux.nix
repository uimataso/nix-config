{ config, lib, pkgs, ... }:

# TODO: with ssh
# TODO: send command
# TODO: theme support

# https://man.archlinux.org/man/tmux.1

with lib;

let
  cfg = config.myConfig.sh-util.tmux;
in {
  options.myConfig.sh-util.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      t = "tmux";
    };

    programs.tmux = {
      enable = true;

      escapeTime = 10;
      terminal = "screen-256color";
      baseIndex = 1;
      newSession = true;
      mouse = true;
      keyMode = "vi";
      # disableConfirmationPrompt = true;

      extraConfig = ''
        # keybind to reload config
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        bind C-b run-shell 'tmux popup -E "tmuxinator-fzf"'
        bind BSpace last-window

        bind g run-shell 'tmux popup -h90% -w90% -E "lazygit"'

        # hjkl to switch
        bind -r h previous-window
        bind -r j select-pane -t :.+
        bind -r k select-pane -t :.-
        bind -r l next-window

        # split in same dir
        bind '"' split-window -v -c "#{pane_current_path}"
        bind  %  split-window -h -c "#{pane_current_path}"

        # better keybind in copy mode
        bind -T copy-mode-vi v   send-keys -X begin-selection
        bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

        set-option -g repeat-time 200

        # status
        set -g status-justify left
        set -g status-left " #{?client_prefix,#[fg=black bg=magenta bright] [#S] #[fg=default bg=default],#[bright] [#S] #[]} "
        set -g status-left-length 20
        set -g status-right "#[bright]#(whoami):#h  "
        setw -g window-status-current-format '-#I:#W- '
        setw -g window-status-format '#[fg=#9b9b9b]#I:#W #[fg=default]'

        set-option -g status-style fg='#9b9b9b',bg=default
        set -g message-style bg=black
        set -g message-command-style bg=black
        set -g mode-style fg=black,bg=green

        # pane border colors
        set -g pane-border-style        fg='#585858'
        set -g pane-active-border-style fg=magenta
        set -g popup-border-style       fg='#585858'

        # window title colors
        set -g window-status-current-style fg=magenta,bg=default,bold
        set -g window-status-style fg=brightwhite,bg=default
      '';

      plugins = with pkgs; [
        {
          # prefix F
          plugin = tmuxPlugins.tmux-fzf;
        }
        {
          # prefix enter
          # TODO: custom fzf header (key hint)
          plugin = tmuxPlugins.extrakto;
          extraConfig = ''
            set -g @extrakto_key enter
            set -g @extrakto_fzf_tool 'fzf --height=100%'
            set -g @extrakto_fzf_layout reverse
            set -g @extrakto_split_direction p
            set -g @extrakto_popup_size 50%
          '';
        }
        {
          # prefix u
          plugin = tmuxPlugins.fzf-tmux-url;
        }
      ];
    };
  };
}
