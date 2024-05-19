{ config, lib, pkgs-unstable, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.nushell;
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
    programs.nushell = {
      package = pkgs-unstable.nushell;
      enable = true;

      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
    };
  };
}
