{ config, pkgs, lib, inputs, ... }:

# TODO:
# flake auto update?
# auto gc working?

{
  home.username = "ui";
  home.homeDirectory = "/home/ui";

  home.stateVersion = "23.11";

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "Sat *-*-* 13:20:00";
  };

  news.display = "silent";

  nixpkgs.config.allowUnfree = true;


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

  imports = [
    ./tmuxinator

    ../common/theme

    ../common/sh
    ../common/sh/bash.nix
    ../common/sh-util

    ../common/xdg.nix
    ../common/direnv.nix

    ../common/apps/firefox
    ../common/apps/st.nix
    ../common/apps/neovim
    ../common/apps/zathura.nix
    ../common/apps/udiskie.nix
    ../common/apps/syncthing.nix

    ../common/xserver
    ../common/xserver/dwm
  ];

  home.packages = with pkgs; [
    wget
    gcc
    git
    qmk
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    dig
    whois

    (callPackage ../common/script/swallower.nix { })
    (callPackage ../common/script/power-menu.nix { })
    (callPackage ../common/script/screenshot.nix { })
    (callPackage ../common/script/build.nix { })
    (callPackage ../common/script/app-launcher.nix { })
    (callPackage ../common/script/extract.nix { })
    (callPackage ../common/script/vl.nix { })
    (callPackage ../common/script/bright.nix { })
    (callPackage ../common/script/open.nix { })
    (callPackage ../common/script/fmenu.nix { })
    (callPackage ../common/script/fff.nix { })

    # TODO:
    # echo "$XDG_BOOKMARK_DIR/bookmark" | entr -np sync-bookmark &
    # ibus
    # clip
    #
    # pdf-decrypt
    # power-menu
  ];
}
