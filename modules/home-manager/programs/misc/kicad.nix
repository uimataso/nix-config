{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.kicad;
in
{
  options.uimaConfig.programs.misc.kicad = {
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
