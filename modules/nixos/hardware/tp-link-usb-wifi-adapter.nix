{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.hardware.tpLinkUsbWifiAdapter;
in
{
  options.uimaConfig.hardware.tpLinkUsbWifiAdapter = {
    enable = mkEnableOption "TP-LINK USB WiFi Adapter";
  };

  config = mkIf cfg.enable {
    # Ref: [this repo](https://github.com/soravoid/nixos-flake/blob/f807c3c38537e3307c3691172ae080b292974a8d/hosts/asrock.nix#L17)

    # Kernel module for TP-LINK USB WiFi Adapter
    boot.extraModulePackages = [ config.boot.kernelPackages.rtl8852au ];
    # Needed for USB WiFi adapter to work
    hardware.usb-modeswitch.enable = true;
  };
}
