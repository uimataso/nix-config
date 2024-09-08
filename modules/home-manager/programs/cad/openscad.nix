{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.cad.openscad;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.cad.openscad = {
    enable = mkEnableOption "OpenSCAD";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/OpenSCAD"
        ".local/share/OpenSCAD/libraries"
        # https://github.com/revarbat/BOSL
        # https://github.com/BelfrySCAD/BOSL2
      ];
    };

    home.packages = with pkgs; [ openscad ];
  };
}
