{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.fmenu;
in
{
  options.uimaConfig.programs.fmenu = {
    enable = mkEnableOption "fmenu. Self written script that using fzf as dmenu.";

    defaultDmenu = mkOption {
      type = types.bool;
      default = false;
      description = "Use fmenu as default dmenu";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ scripts.fmenu ];

    home.sessionVariables = mkIf cfg.defaultDmenu {
      DMENU = "fmenu";
    };
  };
}
