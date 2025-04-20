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

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    timeoutStyle = "hidden";
  };

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

  hardware.keyboard.qmk.enable = true;

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      # sops.enable = true;
      sudo.enable = true;
      autoUpgrade.enable = true;

      impermanence = {
        enable = true;
        btrfs.enable = true;
        btrfs.device = "/dev/sda";
        users = [ "uima" ];
      };
    };

    desktop = {
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
      logitechM650.enable = true;
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
