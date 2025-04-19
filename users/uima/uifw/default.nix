{
  pkgs,
  ...
}:
{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    scripts.app-launcher
    scripts.power-menu
    scripts.screenshot

    scripts.vl
    scripts.clip
    scripts.bright
    scripts.ux
    scripts.open
    scripts.preview
    scripts.pdf-decrypt
    scripts.mkbigfile
  ];

  programs = {
    htop.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    bat.enable = true;
  };

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence = {
        enable = true;
        directories = [
          # Otherwise the cache file will be owned by root
          ".cache/nix"
          "nix"
          "notes"
          "src"
        ];
      };

      # inputMethod.fcitx5.enable = true;
      xdg.enable = true;
      xdgUserDirs.enable = true;
    };

    sh = {
      bash.enable = true;
      bash.defaultShell = true;
    };

    desktop = {
      wayland = {
        river.enable = true;
        waybar.enable = true;
        swww.enable = true;
        dunst.enable = true;
      };
    };

    services = {
      pipewire.enable = true;
      # TODO: is easyeffects actually working?
      easyeffects.enable = true;
      udiskie.enable = true;
      syncthing.enable = true;
    };

    programs = {
      terminal = {
        alacritty.enable = true;
        alacritty.defaultTerminal = true;
      };

      editor = {
        neovim.enable = true;
        neovim.defaultEditor = true;
      };

      # browser = {
      #   librewolf.enable = true;
      #   librewolf.defaultBrowser = true;
      # };

      dev = {
        ssh.enable = true;
        direnv.enable = true;
        git.enable = true;
        lazygit.enable = true;
        docker.enable = true;
        lazydocker.enable = true;
        # podman.enable = true;
        # aws-cli.enable = true;
      };

      dmenu = {
        tofi.enable = true;
        tofi.defaultDmenu = true;
      };

      sh-util = {
        fzf.enable = true;
        fff.enable = true;
        eza.enable = true;
        tmux.enable = true;
        tealdeer.enable = true;
      };

      misc = {
        # # TODO: fix screen sharing on wayland
        # # discord.enable = true;
        # nixcord.enable = true;
        # calibre.enable = true;
        # zathura.enable = true;
        #
        # prusaSlicer.enable = true;
        # kicad.enable = true;
        # freecad.enable = true;
        # openscad.enable = true;
      };
    };
  };
}
