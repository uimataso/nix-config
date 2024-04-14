{ config, pkgs, lib, inputs, ... }:

{
  home.username = "ui";

  home.stateVersion = "23.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "bash";
  };

  home.shellAliases = {
    a = ". fff";
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

    dev = {
      direnv.enable = true;
      git.enable = true;
      lazygit.enable = true;
    };
  };

  home.packages = with pkgs; [
    neovim
    wget
    gcc
    git

    # Scripts
    build
    fff
  ];
}
