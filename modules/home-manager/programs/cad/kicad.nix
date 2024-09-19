{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.cad.kicad;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.cad.kicad = {
    enable = mkEnableOption "KiCad";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/kicad"
        ".local/share/kicad"
      ];
    };

    home.packages = with pkgs; [ kicad-small ];
  };
}
