{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.system.auto-upgrade;
in
{
  options.uimaConfig.system.auto-upgrade = {
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
