{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.services.easyeffects;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.services.easyeffects = {
    enable = mkEnableOption "Easyeffects";
  };

  config = mkIf cfg.enable {
    services.easyeffects.enable = true;

    home.persistence.main = mkIf imper.enable {
      directories = [ ".config/easyeffects" ];
    };
  };
}
