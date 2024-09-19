{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.cad.freecad;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.cad.freecad = {
    enable = mkEnableOption "FreeCad";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/freecad"
        ".local/share/FreeCAD"
      ];
    };

    home.packages = with pkgs; [ freecad ];
  };
}
