{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
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
    libreoffice
    scripts.extract
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
    };

    services = {
      # TODO: This work on wayland?
      easyeffects.enable = true;
    };

    sh = {
      bash.enable = true;
      bash.defaultShell = true;
      nushell.enable = true;
    };

    sh-util = {
      fzf.enable = true;
      fff.enable = true;
      eza.enable = true;
      tmux.enable = true;
      tealdeer.enable = true;
    };

    # desktop.xserver = {
    #   dwm.enable = true;
    #   dunst.enable = true;
    # };

    desktop.wayland = {
      river.enable = true;
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

      alacritty.enable = true;
      foot.enable = true;

      neovim.enable = true;
      neovim.defaultEditor = true;

      firefox.enable = true;
      firefox.profile.uima.enable = true;
      firefox.defaultBrowser = true;

      # qutebrowser.enable = true;

      fmenu.enable = true;
      fmenu.defaultDmenu = true;

      tofi.enable = true;

      pipewire.enable = true;
      ssh.enable = true;
      syncthing.enable = true;
      udiskie.enable = true;
      discord.enable = true;
      zathura.enable = true;

      # kicad.enable = true;
      # freecad.enable = true;
      openscad.enable = true;
      prusa-slicer.enable = true;
    };
  };
}
