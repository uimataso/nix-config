# TODO: secrets
{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.syncthing;
in
{
  options.uimaConfig.services.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".local/share/syncthing"
        ".local/state/syncthing"
      ];
    };

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
