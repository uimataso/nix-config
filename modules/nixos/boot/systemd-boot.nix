{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.boot.systemdBoot;
in
{
  options.uimaConfig.boot.systemdBoot = {
    enable = mkEnableOption "systemd boot";
  };

  config = mkIf cfg.enable { boot.loader.systemd-boot.enable = true; };
}
