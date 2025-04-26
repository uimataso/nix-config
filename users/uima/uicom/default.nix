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
    obsidian
    qmk
    fd
    nsxiv

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

  programs.ssh.matchBlocks = {
    "araizen.github.com" = {
      hostname = "github.com";
      identityFile = [ "~/.ssh/id_ed25519_araizen" ];
      identitiesOnly = true;
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
          ".config/obsidian"
        ];
      };

      inputMethod.fcitx5.enable = true;
      xdgUserDirs.enable = true;
    };

    sh = {
      bash.enable = true;
      bash.defaultShell = true;
      nushell.enable = true;
    };

    desktop = {
      wayland = {
        swww.enable = true;
        dunst.enable = true;
        wlrRandr.enable = true;
      };

      monitors = [
        {
          name = "HDMI-A-1";
          primary = true;
          refreshRate = 144;
        }
      ];
    };

    services = {
      pipewire.enable = true;
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

      browser = {
        librewolf.enable = true;
        librewolf.defaultBrowser = true;
        qutebrowser.enable = true;
      };

      dev = {
        ssh.enable = true;
        direnv.enable = true;
        git.enable = true;
        lazygit.enable = true;
        docker.enable = true;
        lazydocker.enable = true;
        # podman.enable = true;
        aws-cli.enable = true;
      };

      dmenu = {
        fmenu.enable = true;

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
        # TODO: fix screen sharing on wayland
        # discord.enable = true;
        nixcord.enable = true;
        calibre.enable = true;
        zathura.enable = true;

        prusaSlicer.enable = true;
        kicad.enable = true;
        freecad.enable = true;
        openscad.enable = true;
      };
    };
  };
}
