{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.st;
in
{
  options.uimaConfig.programs.st = {
    enable = mkEnableOption "st";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use st as default terminal";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ st ];

    home.sessionVariables = mkIf cfg.defaultTerminal {
      TERMINAL = "st";
    };
  };
}
