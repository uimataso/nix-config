{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.system.autoUpgrade;
in
{
  options.uimaConfig.system.autoUpgrade = {
    enable = mkEnableOption "Auto upgrade";

    allowReboot = mkOption {
      type = types.bool;
      default = false;
      description = "Allow auto reboot when upgrade";
    };

    flake = mkOption {
      type = types.str;
      default = "github:uimataso/nix-config";
      description = "The Flake URI of the NixOS configuration to build";
    };
  };

  config = mkIf cfg.enable {
    # TODO: notify when auto upgrade
    # (https://www.reddit.com/r/NixOS/comments/15yh0qo/systemautoupgrade_with_email_notifications/)
    system.autoUpgrade = {
      enable = true;
      dates = "*-*-* 00/2:00:00"; # Every two hours
      flake = cfg.flake;
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
