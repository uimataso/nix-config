{ config, pkgs, lib, inputs, ... }:

{
  home.username = "ui";
  home.homeDirectory = "/home/ui";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "Sat *-*-* 13:20:00";
  };

  news.display = "silent";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    qmk
    discord
  ];

  imports = [
    ./common/sh
    ./common/sh/bash.nix
    ./common/firefox
    ./common/st.nix
    ./common/neovim

    ./common/colors.nix

    ./common/git.nix
    ./common/xdg.nix
    ./common/zathura.nix

    ./common/udiskie.nix
    ./common/syncthing.nix

    ./common/xserver
    ./common/script
    ./common/statesbar
  ];
}
