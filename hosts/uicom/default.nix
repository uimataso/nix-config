{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "23.11";

  networking.hostName = "uicom";
  time.timeZone = "Asia/Taipei";

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    boot.grub.enable = true;

    system = {
      # sops.enable = true;
      sudo.enable = true;
      auto-upgrade.enable = true;

      impermanence.enable = true;
      impermanence.btrfs.enable = true;
      impermanence.btrfs.device = "/dev/sda";

      pipewire.enable = true;
      udisks2.enable = true;
    };

    # desktop.xserver = {
    #   dwm.enable = true;
    #   sddm.enable = true;
    # };

    desktop.wayland = {
      river.enable = true;
    };

    networking = {
      networkmanager.enable = true;
      tailscale.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      elecom_huge_trackball.enable = true;
    };

    programs = {
      bash.enable = true;
      qmk.enable = true;
    };

    virt = {
      vm.enable = true;
      podman.enable = true;
      docker.enable = true;
      waydroid.enable = true;
    };
  };
}
