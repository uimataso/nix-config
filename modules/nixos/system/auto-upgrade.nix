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

    nix.gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "30min";
      options = "--delete-older-than 30d";
    };

    systemd.services.nixos-upgrade = {
      preStart = ''
        DISPLAY=:0 \
        DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
          ${pkgs.libnotify}/bin/notify-send 'Nixos Upgrade' 'Start upgrading system...'
      '';
      onSuccess = [ "notify-success@nixos-upgrade.service" ];
      onFailure = [ "notify-failure@nixos-upgrade.service" ];
    };

    systemd.services."notify-success@" = {
      enable = true;
      description = "Success notification for %i";
      scriptArgs = ''"%i" "Hostname: %H" "Machine ID: %m" "Boot ID: %b"'';
      script = ''
        unit="$1"
        DISPLAY=:0 \
        DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
          ${pkgs.libnotify}/bin/notify-send "Service '$unit' executed successfully"
      '';
    };

    systemd.services."notify-failure@" = {
      enable = true;
      description = "Failure notification for %i";
      scriptArgs = ''"%i" "Hostname: %H" "Machine ID: %m" "Boot ID: %b"'';
      script = ''
        unit="$1"
        DISPLAY=:0 \
        DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
          ${pkgs.libnotify}/bin/notify-send "Service '$unit' failed"
      '';
    };

  };
}
