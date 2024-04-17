{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.programs.st;
in
{
  options.myConfig.programs.st = {
    enable = mkEnableOption "st";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use st as default terminal";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ my-st ];

    home.sessionVariables = mkIf cfg.defaultTerminal {
      TERMINAL = "st";
    };
  };
}
