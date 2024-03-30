{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.myConfig.misc.settings;
in {
  options.myConfig.misc.settings = {
    enable = mkEnableOption "Misc settings";
    # TODO: dates option
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        use-xdg-base-directories = true;
      };
    };

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
