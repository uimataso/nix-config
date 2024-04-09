{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.services.syncthing;
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
  };
}
