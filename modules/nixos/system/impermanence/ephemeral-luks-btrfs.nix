{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.system.impermanence.luksBtrfs;

  luksName = "crypted";

  wipeScript =
    # sh
    ''
      BTRFS_MNT='/btrfs_tmp'
      BTRFS_SV='@'

      error() {
        echo "$@" >&2
        exit 1
      }

      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "$BTRFS_MNT/$i"
        done
        btrfs subvolume delete "$1" || error "Failed to delete subvolume $1"
      }

      (
        mount -m /dev/mapper/${luksName} "$BTRFS_MNT" || error 'Mount failed'
        trap 'umount "$BTRFS_MNT"' EXIT

        # Backup current subvolume
        mkdir -p "$BTRFS_MNT/snapshots/$BTRFS_SV"
        timestamp=$(date --date="@$(stat -c %Y "$BTRFS_MNT/$BTRFS_SV")" '+%Y-%m-%d_%H:%M:%S')
        mv "$BTRFS_MNT/$BTRFS_SV" "$BTRFS_MNT/snapshots/$BTRFS_SV/$timestamp"

        # Remove the snapshots that is older than 7 day
        find "$BTRFS_MNT/snapshots/$BTRFS_SV" -maxdepth 1 -mtime +7 | while IFS= read -r file; do
          delete_subvolume_recursively "$file"
        done

        # Create clean subvolume
        btrfs subvolume create "$BTRFS_MNT/$BTRFS_SV" || error 'Failed to create subvolume'
      )
    '';

  devToSystemdDevice = dev: (lib.replaceStrings [ "-" "/" ] [ "\\x2d" "-" ] dev) + ".device";
in
{
  options.uimaConfig.system.impermanence.luksBtrfs = {
    enable = mkEnableOption "Impermanence on luks btrfs";

    device = mkOption {
      type = types.str;
      default = "";
      example = "/dev/sda";
      description = "The device that going to implement ephemeral luks btrfs.";
    };
  };

  imports = [ inputs.disko.nixosModules.disko ];

  config = mkIf cfg.enable {
    boot.initrd = {
      enable = true;
      supportedFilesystems = [ "btrfs" ];
      systemd.enable = true;
      systemd.services.restore-root = {
        description = "Rollback btrfs rootfs";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        requires = [
          (devToSystemdDevice "dev/disk/by-partlabel/disk-main-luks")
        ];
        after = [
          (devToSystemdDevice "dev/disk/by-partlabel/disk-main-luks")
          "systemd-cryptsetup@${luksName}.service"
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = wipeScript;
      };
    };

    disko.devices.disk.main = {
      device = cfg.device;
      type = "disk";

      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };

          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = luksName;

              passwordFile = "/tmp/secret.key"; # Interactive
              # ref: https://mynixos.com/nixpkgs/options/boot.initrd.luks.devices.%3Cname%3E
              settings = {
                allowDiscards = true;
              };

              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition

                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
