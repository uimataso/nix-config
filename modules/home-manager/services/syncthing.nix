{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.services.syncthing;

  imper = config.myConfig.system.impermanence;
in
{
  options.myConfig.services.syncthing = {
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
