{ pkgs, lib, ... }:
{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    fd
    minikube
    gnumake
    k6
    redis

    scripts.ux
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
      xdgUserDirs.enable = true;
    };

    sh = {
      bash.enable = true;
      bash.defaultShell = true;
      nushell.enable = true;
    };

    programs = {
      editor = {
        neovim.enable = true;
        neovim.defaultEditor = true;
      };

      sh-util = {
        fzf.enable = true;
        fff.enable = true;
        eza.enable = true;
        tmux.enable = true;
        tealdeer.enable = true;
      };

      dev = {
        ssh.enable = true;
        direnv.enable = true;
        git = {
          enable = true;
          name = "uima-chen";
          email = "uima.chen@araizen.com";
        };
        lazygit.enable = true;
        docker.enable = true;
        k8s.enable = true;
      };
    };
  };
}
