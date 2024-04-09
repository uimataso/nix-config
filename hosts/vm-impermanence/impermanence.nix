{ config, lib, pkgs, ... }:

let
  device = "/dev/vda4";
in
{
  # filesystem modifications needed for impermanence
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  boot.initrd.postDeviceCommands = pkgs.lib.mkAfter ''
    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }

    mkdir /btrfs_tmp
    mount ${device} /btrfs_tmp

    mkdir -p /btrfs_tmp/snapshots
    timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
    mv /btrfs_tmp/@ "/btrfs_tmp/snapshots/$timestamp"

    for i in $(find /btrfs_tmp/snapshots/ -maxdepth 1 -mtime +7); do
      delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/@
    umount /btrfs_tmp
  '';

  users.mutableUsers = false;
  users.users.ui = {
    initialPassword = "password";
    hashedPasswordFile = "/persist/passwords/ui";
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
}
