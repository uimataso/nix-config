{
  config,
  pkgs,
  pkgs-stable,
  lib,
  inputs,
  ...
}:
{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    fd
    scripts.extract
  ];

  programs = {
    htop.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    bat.enable = true;
    ssh.extraConfig = ''
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_uima_chen
        IdentitiesOnly yes

      Host github-personal
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
    '';
  };

  uimaConfig = {
    global.enable = true;

    system = {
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
      eza.enable = true;
      tmux.enable = true;
      tealdeer.enable = true;
    };

    dev = {
      direnv.enable = true;
      git = {
        enable = true;
        name = "Uima";
        email = "uima.chen@araizen.com";
      };
      lazygit.enable = true;
    };

    programs = {
      neovim.enable = true;
      neovim.defaultEditor = true;

      ssh.enable = true;
    };
  };
}
