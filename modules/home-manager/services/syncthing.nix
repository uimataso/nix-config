{ config, lib, ... }:
with lib;
# TODO: secrets
let
  cfg = config.uimaConfig.services.syncthing;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.services.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { directories = [ ".local/share/syncthing" ]; };

    services.syncthing = {
      enable = true;
      extraOptions = [
        "--no-browser"
        "--no-default-folder"
      ];
    };
  };
}
