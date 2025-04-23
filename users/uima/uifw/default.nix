{
  pkgs,
  ...
}:
{
  imports = [
    ./river.nix
    ./waybar.nix
  ];

  home.username = "uima";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    scripts.power-menu
    scripts.app-launcher
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

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs = {
    htop.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    bat.enable = true;
  };

  programs.ssh = {
    extraConfig = ''
      IdentityFile ~/.ssh/id_ed25519.uima
    '';

    matchBlocks = {
      "araizen.github.com" = {
        hostname = "github.com";
        identityFile = [ "~/.ssh/id_ed25519.araizen" ];
        identitiesOnly = true;
      };
    };
  };

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence = {
        enable = true;
        directories = [
          "nix"
          "notes"
          "src"
        ];
      };

      # inputMethod.fcitx5.enable = true;
      xdgUserDirs.enable = true;
    };

    sh = {
      bash.enable = true;
      bash.defaultShell = true;
    };

    desktop = {
      wayland = {
        river.enable = true;
        # waybar.enable = true;
        swww.enable = true;
        dunst.enable = true;
        monitor.enable = true;
      };

      monitors = [
        {
          name = "eDP-1";
          primary = true;
          width = 2880;
          height = 1920;
          refreshRate = 120;
          scale = 2.0;
        }
      ];
    };

    services = {
      pipewire.enable = true;
      udiskie.enable = true;
      # syncthing.enable = true;
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

      browser = {
        librewolf.enable = true;
        librewolf.defaultBrowser = true;
        brave.enable = true;
      };

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

      unfree = {
        google-chrome.enable = true;
        postman.enable = true;
        slack.enable = true;
        notion.enable = true;
      };

      misc = {
        # TODO: fix screen sharing on wayland
        # discord.enable = true;
        nixcord.enable = true;
        # calibre.enable = true;
        zathura.enable = true;

        # prusaSlicer.enable = true;
        # kicad.enable = true;
        # freecad.enable = true;
        # openscad.enable = true;
      };
    };
  };
}
