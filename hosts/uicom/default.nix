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

    users.ui.enable = true;
    system.home-manager.enable = true;
    system.home-manager.users = [ "ui" ];

    system.auto-upgrade.enable = true;

    boot.systemd-boot.enable = true;

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
      doas.enable = true;
      bash.enable = true;
    };

    virt = {
      vm.enable = true;
      podman.enable = true;
    };
  };
}
