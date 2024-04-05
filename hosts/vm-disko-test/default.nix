{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ./disko-config.nix
  ];

  system.stateVersion = "23.11";

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "vm-disko-test";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    gcc
  ];

  myConfig = {
    misc.settings.enable = true;

    users.ui.enable = true;

    services = {
      networkmanager.enable = true;
    };
  };
}
