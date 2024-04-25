{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  system.stateVersion = "23.11";

  networking.hostName = "uicom";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      sudo.enable = true;
      auto-upgrade.enable = true;

      impermanence.enable = true;
      impermanence.btrfs.enable = true;
      impermanence.btrfs.device = "/dev/sda";
    };

    boot.grub.enable = true;

    desktop.fonts.enable = true;
    desktop.xserver = {
      enable = true;
      dwm.enable = true;
      sddm.enable = true;
    };

    networking.networkmanager.enable = true;
    networking.tailscale.enable = true;

    services = {
      pipewire.enable = true;
      udisks2.enable = true;
    };

    programs = {
      bash.enable = true;
      qmk.enable = true;
    };

    virt = {
      vm.enable = true;
      podman.enable = true;
    };
  };
}
