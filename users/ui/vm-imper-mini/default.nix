{ config, pkgs, lib, inputs, ... }:

{
  home.username = "ui";

  home.stateVersion = "23.11";

  home.persistence.main = {
    directories = [
      "nix"
      "src"
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    a = ". fff";
    o = "open";
  };

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence.enable = true;
      xdg.enable = true;
    };

    sh.bash.enable = true;

    dev = {
      direnv.enable = true;
      git.enable = true;
    };
  };

  home.packages = with pkgs; [
    neovim
    fff
  ];
}
