{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.programs.fmenu;
in
{
  options.myConfig.programs.fmenu = {
    enable = mkEnableOption "fmenu. Self written script that using fzf as dmenu.";

    defaultDmenu = mkOption {
      type = types.bool;
      default = false;
      description = "Use fmenu as default dmenu";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ fmenu ];

    home.sessionVariables = mkIf cfg.defaultDmenu {
      DMENU = "fmenu";
    };
  };
}
