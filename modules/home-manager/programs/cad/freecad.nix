{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.freecad;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.freecad = {
    enable = mkEnableOption "FreeCad";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freecad
    ];

    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/freecad"
        ".local/share/FreeCAD"
      ];
    };
  };
}
