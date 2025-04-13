{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.cad.freecad;
in
{
  options.uimaConfig.programs.cad.freecad = {
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
