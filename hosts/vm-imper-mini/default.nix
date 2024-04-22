{ config, lib, pkgs, inputs, outputs, ... }:

# sudo -i
# flake_url='github:uimataso/nix-config#vm-imper-mini'
# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# nixos-install --flake "$flake_url" --no-root-passwd

# chown ui:users /mnt/persist/passwords/ui

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";

  networking.hostName = "vm-imper-mini";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      # sops.enable = true;

      impermanence.enable = true;
      impermanence.btrfs.enable = true;
      impermanence.btrfs.device = "/dev/vda";
    };

    boot.grub.enable = true;

    networking.networkmanager.enable = true;

    services = {
      openssh.enable = true;
    };

    programs = {
      doas.enable = true;
      bash.enable = true;
    };
  };
}
