{ config, pkgs, lib, inputs, ... }:

{
  home.username = "ui";

  home.stateVersion = "23.11";

  home.persistence.main = {
    directories = [
      "nix"
      "src"
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "st";
    DMENU = "fmenu";
    SHELL = "bash";
  };

  home.shellAliases = {
    a = ". fff";
    o = "open";
  };

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence.enable = true;
      xdg.enable = true;
    };

    sh.bash.enable = true;

    misc.nh.enable = true;

    sh-util = {
      misc.enable = true;
      fzf.enable = true;
      lsd.enable = true;
      tmux.enable = true;
      # tmuxinator.enable = true;
      # tmuxinator.dir = ./tmuxinator;
      tealdeer.enable = true;
    };

    desktop.xserver = {
      enable = true;
      wm.dwm.enable = true;

      wallpaper.enable = true;
      wallpaper.imgPath = ../uicom/wallpaper.png;
      dunst.enable = true;
    };

    dev = {
      direnv.enable = true;
      git.enable = true;
      lazygit.enable = true;
    };

    programs = {
      st.enable = true;
      neovim.enable = true;
      firefox.enable = true;
      firefox.profile.ui.enable = true;
      zathura.enable = true;
    };
  };

  home.packages = with pkgs; [
    wget
    gcc
    git

    # Scripts
    build

    fmenu
    fff

    extract
    vl
    bright

    swallower
    screenshot

    open
    power-menu
    app-launcher
  ];
}
