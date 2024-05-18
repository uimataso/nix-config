{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.nushell;
in
{
  options.uimaConfig.sh.nushell = {
    enable = mkEnableOption "Bash";

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

    programs.nushell = {
      enable = true;
    };
  };
}
