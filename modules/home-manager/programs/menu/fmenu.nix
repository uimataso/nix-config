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
    types
    ;
  cfg = config.uimaConfig.programs.menu.fmenu;
in
{
  options.uimaConfig.programs.menu.fmenu = {
    enable = mkEnableOption "fmenu. Self written script that using fzf as dmenu.";

    defaultMenu = mkOption {
      type = types.bool;
      default = false;
      description = "Use fmenu as default menu";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.fmenu ];

    uimaConfig.programs.menu = mkIf cfg.defaultMenu {
      enable = true;
      executable = "fmenu";
    };
  };
}
