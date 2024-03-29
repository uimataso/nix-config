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
    sh.bash.enable = true;

    sh-util = {
      misc.enable = true;
      fzf.enable = true;
      lsd.enable = true;
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

    programs = {
      st.enable = true;
      neovim.enable = true;
      firefox.enable = true;
      firefox.profile.ui.enable = true;
      zathura.enable = true;
    };

    services = {
      syncthing.enable = true;
      udiskie.enable = true;
    };

    misc = {
      settings.enable = true;
      xdg.enable = true;
      theme.enable = true;
    };
  };

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

    (callPackage ../../../modules/home-manager/scripts/script/swallower.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/power-menu.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/screenshot.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/build.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/app-launcher.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/extract.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/vl.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/bright.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/open.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/fmenu.nix { })
    (callPackage ../../../modules/home-manager/scripts/script/fff.nix { })

    # TODO:
    # echo "$XDG_BOOKMARK_DIR/bookmark" | entr -np sync-bookmark &
    # ibus
    # clip
    #
    # pdf-decrypt
    # power-menu
  ];
}
