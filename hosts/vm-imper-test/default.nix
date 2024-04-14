{ config, lib, pkgs, inputs, outputs, ... }:

# sudo -i
# flake_url='github:luck07051/nix-config#vm-imper-test'
# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# nixos-install --flake "$flake_url" --no-root-passwd
# mkdir /mnt/persist/passwords && mkpasswd "pw" > "/mnt/persist/passwords/ui"


{
  imports = [
    ./hardware-configuration.nix
    (import ./disko-config.nix { device = "/dev/vda"; })
    inputs.home-manager.nixosModules.home-manager
  ];

  system.stateVersion = "23.11";

  networking.hostName = "vm-imper-test";
  time.timeZone = "Asia/Taipei";

  myConfig = {
    users.ui.enable = true;

    system.impermanence.enable = true;
    system.impermanence.device = "/dev/vda4";
    system.impermanence.subvolumes = [ "@" ];

    boot.grub.enable = true;

    networking.networkmanager.enable = true;
    services.openssh.enable = true;

    programs = {
      doas.enable = true;
      bash.enable = true;
    };
  };

  users.users.ui.home = "/home/ui";

  home-manager.users.ui = import ../../users/ui/vm-imper-test;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };
}
