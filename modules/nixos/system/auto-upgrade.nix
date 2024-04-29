{ config, lib, inputs, ... }:

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
    # TODO: test this
    system.autoUpgrade = {
      enable = true;
      dates = "22:30";
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
    };

    nix.gc = {
      automatic = true;
      dates = "Mon *-*-* 21:30:00";
      options = "--delete-older-than 7d";
    };
  };
}
