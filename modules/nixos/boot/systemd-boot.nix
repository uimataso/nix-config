{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.boot.systemd-boot;
in {
  options.myConfig.boot.systemd-boot = {
    enable = mkEnableOption "systemd-boot";
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
  };
}
