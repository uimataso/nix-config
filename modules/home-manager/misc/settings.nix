{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.misc.settings;
in {
  options.myConfig.misc.settings = {
    enable = mkEnableOption "Misc settings";

    # TODO: frequency option
  };

  config = mkIf cfg.enable {
    # TODO: test this
    # TODO: flake auto update?
    services.home-manager.autoUpgrade = {
      enable = true;
      frequency = "Sat *-*-* 13:20:00";
    };

    news.display = "silent";

    nixpkgs.config.allowUnfree = true;
  };
}
