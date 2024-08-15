{ config, lib, ... }:
with lib;
# TODO: secrets
let
  cfg = config.uimaConfig.networking.tailscale;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.networking.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    environment.persistence.main = mkIf imper.enable { directories = [ "/var/lib/tailscale" ]; };
  };
}
