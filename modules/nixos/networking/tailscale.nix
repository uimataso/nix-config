# TODO: secrets
{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.networking.tailscale;

  secrets = config.sops.secrets;
in
{
  options.uimaConfig.networking.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ "/var/lib/tailscale" ];
    };

    services.tailscale = {
      enable = true;
      authKeyFile = mkIf (secrets ? "tailscale-auth-key") secrets.tailscale-auth-key.path;
      useRoutingFeatures = "client";
    };
  };
}
