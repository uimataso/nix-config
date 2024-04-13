{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.system.auto-upgrade;
in
{
  options.myConfig.system.auto-upgrade = {
    enable = mkEnableOption "auto upgrade";

    # TODO: frequency option
  };

  config = mkIf cfg.enable {
    # TODO: test this, flake auto update?
    services.home-manager.autoUpgrade = {
      enable = true;
      frequency = "Sat *-*-* 13:20:00";
    };
  };
}
