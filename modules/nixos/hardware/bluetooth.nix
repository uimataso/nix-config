{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.hardware.bluetooth;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.hardware.bluetooth = {
    enable = mkEnableOption "Bluetooth";
  };

  config = mkIf cfg.enable {
    environment.persistence.main = mkIf imper.enable { directories = [ "/var/lib/bluetooth" ]; };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
