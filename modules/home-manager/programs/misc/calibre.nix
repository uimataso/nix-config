{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.calibre;
in
{
  options.uimaConfig.programs.misc.calibre = {
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
