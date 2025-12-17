{
  config,
  lib,
  pkgs,
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
    system.autoUpgrade = {
      enable = true;
      dates = "*-*-* 00/2:00:00"; # Every two hours
      flake = cfg.flake;
      allowReboot = cfg.allowReboot;
    };

    # FIXME: gc keep cleaning pkgs for nix develop
    # nix.gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   randomizedDelaySec = "30min";
    #   options = "--delete-older-than 30d";
    # };

    uimaConfig.services.systemdNotify.services."nixos-upgrade" =
      let
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      in
      {
        onStart = ''--icon ${icon} --urgency=low 'Start NisOS Upgrade...' '';
        onSuccess = ''--icon ${icon} --urgency=low 'NixOS Upgrade Success!' "Upgrade toke $duration seconds"'';
        onFailure = ''--icon ${icon} --urgency=normal 'NixOS Upgrade Failed!' "Upgrade failed at $duration seconds"'';
      };

  };
}
