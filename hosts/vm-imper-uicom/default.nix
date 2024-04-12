{ config, lib, pkgs, inputs, ... }:

# flake_url='github:luck07051/nix-config#vm-imper-uicom'
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# sudo nixos-install --flake "$flake_url" --no-root-passwd

# mkpasswd "$password" > "/persist/passwords/$user"

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-config.nix { device = "/dev/vda"; })
    ./impermanence.nix
  ];

  system.stateVersion = "23.11";

  networking.hostName = "vm-imper-uicom";
  time.timeZone = "Asia/Taipei";

  myConfig = {
    users.ui.enable = true;
    system.impermanence.enable = true;
    boot.grub.enable = true;

    networking.networkmanager.enable = true;
    services.openssh.enable = true;
  };
}
