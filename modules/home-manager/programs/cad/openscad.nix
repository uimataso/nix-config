{
  config,
  lib,
  pkgs,
  ...
}:
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
    home.packages = with pkgs; [ openscad ];

    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/OpenSCAD"
        ".local/share/OpenSCAD/libraries"
        # https://github.com/revarbat/BOSL
        # https://github.com/BelfrySCAD/BOSL2
      ];
    };
  };
}
