{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.openscad;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.openscad = {
    enable = mkEnableOption "OpenSCAD";
  };

  config = mkIf cfg.enable {
    uimaConfig.desktop.gtk.enable = true;

    home.packages = with pkgs; [
      openscad
    ];

    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/OpenSCAD"
      ];
    };
  };
}
