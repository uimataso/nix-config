{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
# TODO: manage default app:
# - terminal
# - editor
# - browser
# - dmenu
# - shell
# TODO: manage scripts
{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.persistence.main = {
    directories = [
      "nix"
      "src"
    ];
  };

  home.packages = with pkgs; [
    qmk
    fd
    scripts.extract
    scripts.app-launcher
    scripts.open
    scripts.power-menu
    scripts.screenshot
    scripts.swallower
    scripts.vl
  ];

  programs.htop.enable = true;
  programs.btop.enable = true;
  programs.ripgrep.enable = true;
  programs.jq.enable = true;
  programs.bat.enable = true;

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence.enable = true;
      input-method.fcitx5.enable = true;
      xdg.enable = true;
      xdg-user-dirs.enable = true;
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
      };
    };

    services = {
      easyeffects.enable = true;
      udiskie.enable = true;
      # syncthing.enable = true;
    };

    programs = {
      terminal = {
        foot.enable = true;
        foot.defaultTerminal = true;
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

      zathura.enable = true;
      prusa-slicer.enable = true;

      cad = {
        # kicad.enable = true;
        # freecad.enable = true;
        openscad.enable = true;
      };
    };
  };
}
