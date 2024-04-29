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

    commitLockFile = mkOption {
      type = types.bool;
      default = false;
      description = "commit lock file when autoupgrade";
    };
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "22:00";
      randomizedDelaySec = "30min";
      flake = flakeDir;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ] ++ lists.optional cfg.commitLockFile "--commit-lock-file";
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
