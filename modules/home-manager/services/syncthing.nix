{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.services.syncthing;

  ifImpermanence = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
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

    home.persistence.main = ifImpermanence {
      directories = [ ".local/share/syncthing" ];
    };
  };
}
