{ ... }:
{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.persistence.main = {
    directories = [
      "nix"
      "src"
    ];
  };

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence.enable = true;
      input-method.enable = true;
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
      fzf.enable = true;
      fff.enable = true;
    };

    desktop.xserver = {
      enable = true;
      wm.dwm.enable = true;
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

      fmenu.enable = true;
      fmenu.defaultDmenu = true;

      ssh.enable = true;
    };
  };
}
