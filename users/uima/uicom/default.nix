{ config, pkgs, lib, inputs, ... }:

{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.persistence.main = {
    directories = [
      "nix"
      "src"

      # TODO: move to pipewire.nix
      ".local/state/wireplumber"
    ];
  };

  uimaConfig = {
    global.enable = true;

    system = {
      ssh.enable = true;
      impermanence.enable = true;
      auto-upgrade.enable = true;
      xdg.enable = true;
    };

    sh.bash.enable = true;
    sh.bash.defaultShell = true;

    sh-util = {
      misc.enable = true;
      fzf.enable = true;
      fff.enable = true;
      bat.enable = true;
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
      st.defaultTerminal = true;

      neovim.enable = true;
      neovim.defaultEditor = true;

      firefox.enable = true;
      firefox.profile.uima.enable = true;
      firefox.defaultBrowser = true;

      fmenu.enable = true;
      fmenu.defaultDmenu = true;

      discord.enable = true;
      zathura.enable = true;
    };

    services = {
      syncthing.enable = true;
      udiskie.enable = true;
    };
  };

  home.packages = with pkgs; [
    # qmk
    # dig
    # whois

    # Scripts
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
