{ config, lib, pkgs, ... }:

# https://man.archlinux.org/man/tmux.1

with lib;

let
  cfg = config.uimaConfig.sh-util.tmux;

  setEnvVar = {pkg, binPath, name, val}: pkg.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];
    postInstall = old.postInstall or "" + ''
      wrapProgram "$out/${binPath}" --set ${name} ${val}
    '';
  });

  scheme = config.scheme;
in
{
  options.uimaConfig.sh-util.tmux = {
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
        set -g set-clipboard external

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
        setw -g window-status-format '#[fg=#${scheme.base06}]#I:#W #[fg=default]'

        set-option -g status-style fg='#${scheme.base06}',bg=default
        set -g message-style bg=black
        set -g message-command-style bg=black
        set -g mode-style fg=black,bg=green

        # pane border colors
        set -g pane-border-style        fg='#${scheme.base04}'
        set -g pane-active-border-style fg=magenta
        set -g popup-border-style       fg='#${scheme.base04}'

        # window title colors
        set -g window-status-current-style fg=magenta,bg=default,bold
        set -g window-status-style fg=brightwhite,bg=default
      '';

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.tmux-nvim;
        }
        {
          # prefix F
          plugin = tmuxPlugins.tmux-fzf;
        }
        {
          # prefix enter
          plugin = tmuxPlugins.extrakto;
          extraConfig = let
            myFzf = pkgs.writeShellScriptBin "myFzf" ''
              ${pkgs.fzf}/bin/fzf --color=pointer:5 "$@"
            '';
          in ''
            set -g @extrakto_key enter
            set -g @extrakto_fzf_tool "${myFzf}/bin/myFzf"
            set -g @extrakto_fzf_layout reverse
            set -g @extrakto_split_direction p
            set -g @extrakto_popup_size 50%
            set -g @extrakto_fzf_header "f g i c"
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
