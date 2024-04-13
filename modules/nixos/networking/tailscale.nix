{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.networking.tailscale;
  ifImpermanence = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
in
{
  options.myConfig.networking.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    # TODO: manage tailscale key etc
    services.tailscale.enable = true;

    environment.persistence.main = ifImpermanence {
      directories = [
        "/var/lib/tailscale"
      ];
    };
  };
}
