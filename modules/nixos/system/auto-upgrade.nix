{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.myConfig.system.auto-upgrade;
in
{
  options.myConfig.system.auto-upgrade = {
    enable = mkEnableOption "auto upgrade";
    # TODO: dates option
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

    nix.optimise = {
      automatic = true;
      dates = [ "23:00" ];
    };

    nix.gc = {
      automatic = true;
      dates = "Mon *-*-* 21:30:00";
      options = "--delete-older-than 7d";
    };
  };
}
