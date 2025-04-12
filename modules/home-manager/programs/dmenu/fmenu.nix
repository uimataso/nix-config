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
  cfg = config.uimaConfig.programs.dmenu.fmenu;
in
{
  options.uimaConfig.programs.dmenu.fmenu = {
    enable = mkEnableOption "fmenu. Self written script that using fzf as dmenu.";

    defaultDmenu = mkOption {
      type = types.bool;
      default = false;
      description = "Use fmenu as default dmenu";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.fmenu ];

    uimaConfig.programs.dmenu = mkIf cfg.defaultDmenu {
      enable = true;
      executable = "fmenu";
    };
  };
}
