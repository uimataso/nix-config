{ config, pkgs, ... }:

# TODO:
# session manager? resurrect nvim
# with ssh
# send command (after this, delete toggle plugin in nvim)
# theme

{
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
      # hjkl to switch
      bind-key h previous-window
      bind-key j select-pane -t :.+
      bind-key k select-pane -t :.-
      bind-key l next-window

      # split in same dir
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # better keybind in copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # status
      set -g status-justify left
      set -g status-left " #{?client_prefix,#[fg=black bg=magenta bright] [#S] #[fg=default bg=default],#[bright] [#S] #[]} "
      set -g status-left-length 15
      set -g status-right "#[bright]#(users):#(hostname) "
      setw -g window-status-current-format '-#I:#W- '
      setw -g window-status-format '#[fg=#9b9b9b]#I:#W #[fg=default]'

      set-option -g status-style fg='#9b9b9b',bg=default
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
          set -g @resurrect-dir '${config.xdg.dataHome}/tmux/resurrect'
          # set -g @resurrect-strategy-nvim 'session'
          # set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'
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
      {
        # Prefix Space
        plugin = tmuxPlugins.tmux-thumbs;
        extraConfig = "set -g @thumbs-command 'echo -n {} | xclip -sel clip'";
      }
      {
        # Prefix Tab
        plugin = tmuxPlugins.extrakto;
        extraConfig = ''
          set -g @extrakto_split_direction v
          set -g @extrakto_split_size 15
        '';
      }
      {
        # Prefix u
        plugin = tmuxPlugins.fzf-tmux-url;
      }
    ];
  };
}
