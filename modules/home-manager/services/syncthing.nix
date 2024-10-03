{ config, lib, ... }:
# TODO: secrets
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.syncthing;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.services.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { directories = [ ".local/share/syncthing" ]; };

    home.shellAliases = {
      syncb = "syncthing serve --browser-only";
    };

    services.syncthing = {
      enable = true;
      extraOptions = [
        "--no-browser"
        "--no-default-folder"
      ];
    };
  };
}
