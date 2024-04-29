{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.auto-upgrade;

  flakeDir = "$HOME/nix";
  flakeUri = "github:luck07051/nix-config";
in
{
  options.uimaConfig.system.auto-upgrade = {
    enable = mkEnableOption "Auto upgrade";

    allowReboot = mkOption {
      type = types.bool;
      default = false;
      description = "Allow auto reboot when upgrade";
    };
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "22:00";
      randomizedDelaySec = "30min";
      flake = flakeUri;
      allowReboot = cfg.allowReboot;
    };

    nix.gc = {
      automatic = true;
      dates = "Mon *-*-* 21:30:00";
      randomizedDelaySec = "30min";
      options = "--delete-older-than 7d";
    };
  };
}
