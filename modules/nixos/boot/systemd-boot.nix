{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.boot.systemd-boot;
in
{
  options.uimaConfig.boot.systemd-boot = {
    enable = mkEnableOption "systemd-boot";
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
  };
}
