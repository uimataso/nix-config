{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../common/user/ui.nix

    ../common/xserver/dwm.nix
    ../common/xserver/sddm.nix

    ../common/pipewire.nix
    ../common/fonts.nix
    ../common/bash.nix
    ../common/doas.nix
  ];

  system.stateVersion = "23.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    gcc
  ];

  system.autoUpgrade = {
    enable = true;
    dates = "22:30";
    flake = inputs.self.outPath;
    flags = [
      "--update-input" "nixpkgs"
      "-L" # print build logs
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "Mon *-*-* 21:30:00";
    options = "--delete-older-than 7d";
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    timeoutStyle = "hidden";
  };

  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "vm";
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  services.tailscale.enable = true;

  # for udiskie to work
  services.udisks2.enable = true;
}
