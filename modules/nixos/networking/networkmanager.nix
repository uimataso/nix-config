{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.networking.networkmanager;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.networking.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };

  config = mkIf cfg.enable {
    environment.persistence.main = mkIf imper.enable {
      directories = [ "/etc/NetworkManager/system-connections" ];
    };

    networking.networkmanager.enable = true;

    # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  };
}
