{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.networking.tailscale;

  imper = config.myConfig.system.impermanence;
in
{
  options.myConfig.networking.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    # TODO: manage tailscale key etc
    services.tailscale.enable = true;

    environment.persistence.main = mkIf imper.enable {
      directories = [
        "/var/lib/tailscale"
      ];
    };
  };
}
