{ config, pkgs, lib, inputs, ... }:

{
  home.username = "ui";

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
      misc.enable = true;
      fzf.enable = true;
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
  ];
}
