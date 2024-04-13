{ config, lib, pkgs, inputs, ... }:

# flake_url='github:luck07051/nix-config#vm-imper-uicom'
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# sudo nixos-install --flake "$flake_url" --no-root-passwd

# sudo -i
# mkpasswd "$password" > "/mnt/persist/passwords/$user"

{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-config.nix { device = "/dev/vda"; })
  ];

  system.stateVersion = "23.11";

  networking.hostName = "vm-imper-uicom";
  time.timeZone = "Asia/Taipei";

  myConfig = {
    users.ui.enable = true;
    system.impermanence.enable = true;
    system.impermanence.device = "/dev/vda4";
    boot.grub.enable = true;

    networking.networkmanager.enable = true;
    networking.tailscale.enable = true;
    services.openssh.enable = true;

    desktop.fonts.enable = true;
    desktop.xserver = {
      enable = true;
      dwm.enable = true;
      sddm.enable = true;
    };

    services = {
      pipewire.enable = true;
      udisks2.enable = true;
    };

    programs = {
      doas.enable = true;
      bash.enable = true;
    };
  };
}
