{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.cad.kicad;
in
{
  options.uimaConfig.programs.cad.kicad = {
    enable = mkEnableOption "KiCad";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/kicad"
        ".local/share/kicad"
      ];
    };

    home.packages = with pkgs; [ kicad-small ];
  };
}
