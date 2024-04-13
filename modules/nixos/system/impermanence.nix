{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.myConfig.system.impermanence;
in
{
  options.myConfig.system.impermanence = {
    enable = mkEnableOption "Impermanence on btrfs";

    device = mkOption {
      type = types.str;
      default = "";
      example = "/dev/sda4";
      description = "TODO:";
    };

    persist_dir = mkOption {
      type = types.str;
      default = "/persist";
      example = "/nix/persistent";
      description = "The directory to store persistent data.";
    };

    subvolumes = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "@" "@home" ];
      description = "List of subvolumes to clean up at boot.";
    };

    delete-older-then = mkOption {
      type = types.int;
      default = 7;
      example = 30;
      description = "Delete the snapshots that older then this value days.";
    };
  };

  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  config = mkIf cfg.enable {
    # Filesystem modifications needed for impermanence
    fileSystems.${cfg.persist_dir}.neededForBoot = true;

    boot.initrd.postDeviceCommands = pkgs.lib.mkAfter ''
      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      mkdir /btrfs_tmp
      mount ${cfg.device} /btrfs_tmp

      for sv in ${lib.strings.escapeShellArgs cfg.subvolumes}; do
        mkdir -p "/btrfs_tmp/snapshots/$sv"
        timestamp=$(date --date="@$(stat -c %Y "/btrfs_tmp/$sv")" "+%Y-%m-%-d_%H:%M:%S")
        mv "/btrfs_tmp/$sv" "/btrfs_tmp/snapshots/$sv/$timestamp"

        for i in $(find "/btrfs_tmp/snapshots/$sv" -maxdepth 1 -mtime +${lib.strings.escapeShellArg cfg.delete-older-then}); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create "/btrfs_tmp/$sv"
      done

      umount /btrfs_tmp
    '';

    programs.fuse.userAllowOther = true;
    users.mutableUsers = false;

    # Default persistence files
    environment.persistence.main = {
      persistentStoragePath = cfg.persist_dir;
      hideMounts = true;

      directories = [
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/log"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };
}
