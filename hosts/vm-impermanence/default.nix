{ config, lib, pkgs, inputs, ... }:

# flake_url='github:luck07051/nix-config#vm-impermanence'
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# sudo nixos-install --flake "$flake_url"

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-config.nix { device = "/dev/vda"; })
    ./impermanence.nix
  ];

  system.stateVersion = "23.11";

  networking.hostName = "vm-disko-test";

  networking.networkmanager.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    gcc
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  users.users.ui = {
    isNormalUser = true;
    initialPassword = "pw";
    extraGroups = [ "wheel" ];
  };
}
