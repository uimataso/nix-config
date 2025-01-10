{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.programs.calibre;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.calibre = {
    enable = mkEnableOption "calibre";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".local/share/calibre"
        ".config/calibre"
      ];
    };

    home.packages = with pkgs; [
      pkgs-stable.calibre
    ];
  };
}
