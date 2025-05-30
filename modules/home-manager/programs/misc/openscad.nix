{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.openscad;
in
{
  options.uimaConfig.programs.misc.openscad = {
    enable = mkEnableOption "OpenSCAD";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
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
