{ config, lib, ... }:
# TODO: secrets
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.networking.tailscale;
in
{
  options.uimaConfig.networking.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ "/var/lib/tailscale" ];
    };

    services.tailscale.enable = true;
  };
}
