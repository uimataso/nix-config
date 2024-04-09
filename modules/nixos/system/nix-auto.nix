{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.myConfig.system.nix-auto;
in
{
  options.myConfig.system.nix-auto = {
    enable = mkEnableOption "nix auto";
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
