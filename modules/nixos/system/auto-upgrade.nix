{ config
, lib
, ...
}:
with lib;
let
  cfg = config.uimaConfig.system.autoUpgrade;

  flakeUri = "github:luck07051/nix-config";
in
{
  options.uimaConfig.system.autoUpgrade = {
    enable = mkEnableOption "Auto upgrade";

    allowReboot = mkOption {
      type = types.bool;
      default = false;
      description = "Allow auto reboot when upgrade";
    };
  };

  config = mkIf cfg.enable {
    # TODO: nofy when auto upgrade
    # (https://www.reddit.com/r/NixOS/comments/15yh0qo/systemautoupgrade_with_email_notifications/)
    system.autoUpgrade = {
      enable = true;
      dates = "*-*-* 00/2:00:00"; # Every two hours
      flake = flakeUri;
      allowReboot = cfg.allowReboot;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "30min";
      options = "--delete-older-than 30d";
    };
  };
}
