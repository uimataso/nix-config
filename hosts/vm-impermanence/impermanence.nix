{ config, lib, pkgs, ... }:

{
  # filesystem modifications needed for impermanence
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  boot.initrd.postDeviceCommands = pkgs.lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/vda4 /btrfs_tmp

    echo 'imper: start restore'

    mkdir -p /btrfs_tmp/snapshots
    timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
    mv /btrfs_tmp/@ "/btrfs_tmp/snapshots/$timestamp"

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

  # boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
  #   mkdir -p /mnt
  #
  #   # Mount the btrfs root to /mnt
  #   mount -o subvol="@" /dev/vda3 /mnt
  #
  #   # Delete the root subvolume
  #   echo "deleting root subvolume..." &&
  #   btrfs subvolume delete /mnt/root
  #
  #   # Restore new root from root-blank
  #   echo "restoring blank @root subvolume..."
  #   btrfs subvolume snapshot /mnt/root-blank /mnt/root
  #
  #   # Unmount /mnt and continue boot process
  #   umount /mnt
  # '';
}
