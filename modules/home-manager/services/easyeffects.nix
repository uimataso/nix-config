{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.easyeffects;
in
{
  options.uimaConfig.services.easyeffects = {
    enable = mkEnableOption "Easyeffects";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/easyeffects"
      ];
    };

    services.easyeffects = {
      enable = true;
    };
  };
}
