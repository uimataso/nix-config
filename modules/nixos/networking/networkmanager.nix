{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.networking.networkmanager;
in {
  options.myConfig.networking.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

    # environment.persistence."/persist" = {
    #   directories = [
    #     "/etc/NetworkManager/system-connections"
    #   ];
    # };
  };
}
