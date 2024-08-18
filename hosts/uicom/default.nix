{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  system.stateVersion = "23.11";

  networking.hostName = "uicom";
  time.timeZone = "Asia/Taipei";

  # Help my poor networking
  # services.dnsmasq = {
  #   enable = true;
  #   settings = {
  #     address = "/#.uima.duckdns.org/uima.duckdns.org/ui.pi/192.168.1.113";
  #   };
  # };

  hardware.nvidia = {
    # open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  services.xserver.extraConfig = ''
    Section "InputClass"
      Identifier "ELECOM trackball catchall"
      MatchProduct "ELECOM TrackBall Mouse HUGE TrackBall"
      MatchVendor "ELECOM"
      MatchIsPointer "yes"
      Driver "libinput"
      Option "Buttons" "12"
      Option "ButtonMapping" "1 2 2 4 5 6 7 8 12 10 11 3"
      Option "EmulateWheel" "true"
      Option "EmulateWheelButton" "9"
      Option "EmulateWheelTimeout" "0"
      Option "ScrollMethod" "button"
      Option "ScrollButton" "9"
      Option "ScrollPixelDistance" "32"
    EndSection
  '';

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

    programs = {
      bash.enable = true;
      qmk.enable = true;
    };

    virt = {
      vm.enable = true;
      podman.enable = true;
      docker.enable = true;
    };
  };
}
