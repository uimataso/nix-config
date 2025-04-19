{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.networking.networkmanager;
in
{
  options.uimaConfig.networking.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ "/etc/NetworkManager/system-connections" ];
    };

    networking.networkmanager.enable = true;

    # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  };
}
