{ config, pkgs, lib, inputs, ... }:

{
  home.username = "ui";
  home.homeDirectory = "/home/ui";

  home.stateVersion = "23.11";

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

  myConfig = {
    system = {
      impermanence.enable = true;
      xdg.enable = true;
    };

    sh.bash.enable = true;

    sh-util = {
      fzf.enable = true;
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
    };

    misc = {
      theme.enable = true;
    };
  };

  home.packages = with pkgs; [
    wget
    gcc
    git
    qmk

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
