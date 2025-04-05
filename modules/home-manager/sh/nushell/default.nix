{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    types
    ;
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

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { files = [ ".config/nushell/history.txt" ]; };

    uimaConfig.sh = mkIf cfg.defaultShell {
      enable = true;
      executable = "nu";
      tmuxShell = "${config.programs.nushell.package}/bin/nu";
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

        l = mkDefault "ls";
        ls = mkDefault "ls -a";
        ll = mkDefault "ls -al";

        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -ivr";
        md = "mkdir -v";

        df = "df -h";
      };
    };
  };
}
