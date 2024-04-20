{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.services.syncthing;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.services.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      extraOptions = [
        "--no-browser"
        "--no-default-folder"
      ];
    };

    home.persistence.main = mkIf imper.enable {
      directories = [ ".local/share/syncthing" ];
    };
  };
}
