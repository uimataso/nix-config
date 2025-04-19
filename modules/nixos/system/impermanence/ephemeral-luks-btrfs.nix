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

  deviceName = "/dev/disk/by-partlabel/disk-main-luks";
  systemdRootDevice = "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2dluks.device";

  wipeScript =
    # sh
    ''
      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      mkdir /btrfs_tmp
      mount ${deviceName} /btrfs_tmp

      sv='@'

      mkdir -p "/btrfs_tmp/snapshots/$sv"
      timestamp=$(date --date="@$(stat -c %Y "/btrfs_tmp/$sv")" "+%Y-%m-%-d_%H:%M:%S")
      mv "/btrfs_tmp/$sv" "/btrfs_tmp/snapshots/$sv/$timestamp"

      for i in $(find "/btrfs_tmp/snapshots/$sv" -maxdepth 1 -mtime +7); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create "/btrfs_tmp/$sv"

      umount /btrfs_tmp
    '';
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
        requires = [ systemdRootDevice ];
        after = [
          systemdRootDevice
          "systemd-cryptsetup@${config.networking.hostName}.service"
        ];
        before = [ "sysroot.mount" ];
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
              name = "crypted";

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
