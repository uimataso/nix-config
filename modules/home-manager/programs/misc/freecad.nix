{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.freecad;
in
{
  options.uimaConfig.programs.misc.freecad = {
    enable = mkEnableOption "FreeCad";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/FreeCAD"
        ".local/share/FreeCAD"
      ];
    };

    home.packages = with pkgs; [ freecad ];
  };
}
