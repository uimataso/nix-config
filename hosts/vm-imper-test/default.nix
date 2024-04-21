{ config, lib, pkgs, inputs, outputs, ... }:

# sudo -i
# flake_url='github:luck07051/nix-config#vm-imper-test'
# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# nixos-install --flake "$flake_url" --no-root-passwd

# mkdir -p /mnt/persist/home/ui
# mkdir /mnt/persist/passwords && mkpasswd "pw" > "/mnt/persist/passwords/ui"

# chown ui:users /mnt/persist/home/ui
# chown ui:users /mnt/persist/passwords/ui


{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";

  networking.hostName = "vm-imper-test";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.ui.enable = true;

    system = {
      impermanence.enable = true;
      impermanence.btrfs.enable = true;
      impermanence.btrfs.device = "/dev/vda";
    };

    boot.grub.enable = true;

    networking.networkmanager.enable = true;

    desktop.fonts.enable = true;
    desktop.xserver = {
      enable = true;
      dwm.enable = true;
      sddm.enable = true;
    };

    services = {
      openssh.enable = true;
      pipewire.enable = true;
      udisks2.enable = true;
    };

    programs = {
      doas.enable = true;
      bash.enable = true;
    };
  };
}
