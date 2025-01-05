{ pkgs
, ...
}:
# TODO: manage scripts
# TODO: check easyeffects and discord screen sharing
{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.persistence.main = {
    directories = [
      "nix"
      "notes"

      # "src"
      {
        directory = "src";
        method = "symlink";
      }
    ];
  };

  home.packages = with pkgs; [
    qmk
    fd
    extract
    app-launcher
    open
    power-menu
    screenshot
    swallower
    vl
    mkbigfile
  ];

  programs = {
    htop.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    bat.enable = true;

    ssh.extraConfig = ''
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes

      Host github-araizen
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_araizen
        IdentitiesOnly yes
    '';
  };

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence.enable = true;
      inputMethod.fcitx5.enable = true;
      xdg.enable = true;
      xdgUserDirs.enable = true;
      pipewire.enable = true;
    };

    sh = {
      bash.enable = true;
      bash.defaultShell = true;
      nushell.enable = true;
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
        firefox.enable = true;
        firefox.profile.uima.enable = true;
        firefox.defaultBrowser = true;
      };

      dev = {
        ssh.enable = true;
        direnv.enable = true;
        git.enable = true;
        lazygit.enable = true;
        docker.enable = true;
        lazydocker.enable = true;
        # podman.enable = true;
      };

      menu = {
        fmenu.enable = true;

        tofi.enable = true;
        tofi.defaultMenu = true;
      };

      sh-util = {
        fzf.enable = true;
        fff.enable = true;
        eza.enable = true;
        tmux.enable = true;
        tealdeer.enable = true;
      };

      nixcord.enable = true;

      calibre.enable = true;

      zathura.enable = true;
      wikiman.enable = true;
      prusaSlicer.enable = true;

      cad = {
        # kicad.enable = true;
        # freecad.enable = true;
        openscad.enable = true;
      };
    };
  };
}
