{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.nushell;

  imper = config.uimaConfig.system.impermanence;
  defaultEditor = config.home.sessionVariables.EDITOR;
in
{
  options.uimaConfig.sh.nushell = {
    enable = mkEnableOption "Nushell";

    defaultShell = mkOption {
      type = types.bool;
      default = false;
      description = "Use Nushell as default shell";
    };
  };

  config = mkIf cfg.enable rec {
    home.sessionVariables = mkIf cfg.defaultShell {
      SHELL = "nu";
    };

    # TODO:
    # - fff
    # - fzf-complete
    # - tmuxintor
    # - completion
    # - history persist
    programs.nushell = {
      package = pkgs.nushell;
      enable = true;

      configFile.source = ./config.nu;
      envFile.source = ./env.nu;

      shellAliases = {
        c = "cd";
        "c." = "cd ..";
        c- = "cd -";
        c_ = "cd $env._";

        e = "${defaultEditor}";
        "e." = "${defaultEditor} .";

        l = "ls";
        ls = "ls -a";
        ll = "ls -al";

        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -ivr";
        md = "mkdir -v";

        df = "df -h";
      };
    };

    home.persistence.main = mkIf imper.enable {
      files = [
        ".config/nushell/history.txt"
      ];
    };
  };
}
