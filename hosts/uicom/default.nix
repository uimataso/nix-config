{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "23.11";

  networking.hostName = "uicom";
  time.timeZone = "Asia/Taipei";

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  hardware.keyboard.qmk.enable = true;

  networking = {
    interfaces.enp7s0 = {
      ipv4.addresses = [
        {
          address = "192.168.10.10";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.10.1";
      interface = "enp7s0";
    };
    nameservers = [
      "192.168.10.1"
    ];
  };

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    boot.grub.enable = true;

    system = {
      # sops.enable = true;
      sudo.enable = true;
      autoUpgrade.enable = true;

      impermanence.enable = true;
      impermanence.btrfs.enable = true;
      impermanence.btrfs.device = "/dev/sda";
    };

    desktop = {
      # xserver = {
      #   dwm.enable = true;
      #   sddm.enable = true;
      # };

      # TODO: auto start
      wayland = {
        river.enable = true;
      };
    };

    networking = {
      networkmanager.enable = true;
      tailscale.enable = true;
    };

    hardware = {
      pipewire.enable = true;
      bluetooth.enable = true;
      elecomHugeTrackball.enable = true;
      tpLinkUsbWifiAdapter.enable = true;
    };

    services = {
      udisks2.enable = true;
    };

    virt = {
      vm.enable = true;
      podman.enable = true;
      docker.enable = true;
      waydroid.enable = true;
    };
  };
}
