{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.kicad;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.kicad = {
    enable = mkEnableOption "KiCad";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kicad-small ];

    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/kicad"
        ".local/share/kicad"
      ];
    };
  };
}
