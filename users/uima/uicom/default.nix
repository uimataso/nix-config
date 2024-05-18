{ config, pkgs, lib, inputs, ... }:

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
  ];

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence.enable = true;
      xdg.enable = true;
      xdg-user-dirs.enable = true;
    };

    sh = {
      bash.enable = true;
      # bash.defaultShell = true;
      nushell.enable = true;
      nushell.defaultShell = true;
    };

    sh-util = {
      misc.enable = true;
      fzf.enable = true;
      fff.enable = true;
      bat.enable = true;
      eza.enable = true;
      tmux.enable = true;
      tmuxinator.enable = true;
      tmuxinator.dir = ./tmuxinator;
      tealdeer.enable = true;
    };

    desktop.xserver = {
      enable = true;
      wm.dwm.enable = true;

      wallpaper.enable = true;
      wallpaper.imgPath = ./wallpaper.png;
      dunst.enable = true;
    };

    dev = {
      direnv.enable = true;
      git.enable = true;
      lazygit.enable = true;
    };

    virt = {
      docker.enable = true;
      # podman.enable = true;
    };

    programs = {
      st.enable = true;
      st.defaultTerminal = true;

      neovim.enable = true;
      neovim.defaultEditor = true;

      firefox.enable = true;
      firefox.profile.uima.enable = true;
      firefox.defaultBrowser = true;

      fmenu.enable = true;
      fmenu.defaultDmenu = true;

      pipewire.enable = true;
      ssh.enable = true;
      syncthing.enable = true;
      udiskie.enable = true;
      discord.enable = true;
      zathura.enable = true;

      kicad.enable = true;
      freecad.enable = true;
      openscad.enable = true;
      prusa-slicer.enable = true;
    };
  };
}
