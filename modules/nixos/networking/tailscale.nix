{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.networking.tailscale;
in {
  options.myConfig.networking.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    # TODO: manage tailscale key etc
    services.tailscale.enable = true;
  };
}
