{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  system.stateVersion = "23.11";

  boot.loader.systemd-boot.enable = true;

  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "uicom";

  # services.openssh.enable = true;

  # TODO: manage tailscale key etc
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    gcc
  ];

  myConfig = {
    system.nix-settings.enable = true;
    system.nix-auto.enable = true;

    users.ui.enable = true;

    desktop.fonts.enable = true;

    desktop.xserver = {
      enable = true;
      dwm.enable = true;
      sddm.enable = true;
    };

    networking.networkmanager.enable = true;

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
