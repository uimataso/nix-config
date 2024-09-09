{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.menu.fmenu;
in
{
  options.uimaConfig.programs.menu.fmenu = {
    enable = mkEnableOption "fmenu. Self written script that using fzf as dmenu.";

    defaultMenu = mkOption {
      type = types.bool;
      default = false;
      description = "Use fmenu as default dmenu";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ scripts.fmenu ];

    home.sessionVariables = mkIf cfg.defaultMenu { DMENU = "fmenu"; };
  };
}
