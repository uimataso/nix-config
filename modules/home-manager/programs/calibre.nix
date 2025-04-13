{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.calibre;
in
{
  options.uimaConfig.programs.calibre = {
    enable = mkEnableOption "calibre";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".local/share/calibre"
        ".config/calibre"
      ];
    };

    home.packages = with pkgs; [
      calibre
    ];
  };
}
