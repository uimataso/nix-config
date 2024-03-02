{ pkgs, ... }:

# TODO:
# session manager?

{
  home.shellAliases = {
    t = "tmux";
    ta = "tmux new-session -A -s";
  };

  programs.tmux = {
    enable = true;

    escapeTime = 10;
    terminal = "screen-256color";
    baseIndex = 1;
    newSession = true;
    mouse = true;
    # keyMode = "vi";
    # disableConfirmationPrompt = true;

    extraConfig = ''
      set -g status-justify left
      set -g status-left " #{?client_prefix,#[fg=black bg=magenta] [#S] #[fg=default bg=default], [#S] } "
      set -g status-left-length 15
      set -g status-right "#[bright]#(users):#(hostname) "
      setw -g window-status-current-format '-#I:#W- '
      setw -g window-status-format '#I:#W '

      set-option -g status-style bg=default
      set -g message-style bg=black
      set -g message-command-style bg=black
      set -g mode-style fg=black,bg=green

      # pane border colors
      set -g pane-border-style        fg='#585858'
      set -g pane-active-border-style fg=magenta

      # window title colors
      set -g window-status-current-style fg=magenta,bg=default,bold
      set -g window-status-style fg=brightwhite,bg=default
      '';

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
        set -g @resurrect-strategy-nvim 'session'
        bind-key d run-shell "#{@resurrect-save-script-path} quiet" \; detach-client
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      {
        plugin = tmuxPlugins.tmux-fzf;
      }
      { # Prefix Space
        plugin = tmuxPlugins.tmux-thumbs;
        extraConfig = "set -g @thumbs-command 'echo -n {} | xclip -sel clip'";
      }
      { # Prefix Tab
        plugin = tmuxPlugins.extrakto;
        extraConfig = ''
          set -g @extrakto_split_direction v
          set -g @extrakto_split_size 15
        '';
      }
      { # Prefix u
        plugin = tmuxPlugins.fzf-tmux-url;
      }
    ];
  };
}
