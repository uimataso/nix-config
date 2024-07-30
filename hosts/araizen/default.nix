{ config, lib, pkgs, inputs, ... }:

{
  # imports = [
  #   ./hardware-configuration.nix
  #   ./nvidia.nix
  # ];

  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "23.11";

  wsl.enable = true;
  programs.dconf.enable = true;

  networking.hostName = "araizen";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      # sops.enable = true;
      sudo.enable = true;
      auto-upgrade.enable = true;

      # impermanence.enable = true;
      # impermanence.btrfs.enable = true;
      # impermanence.btrfs.device = "/dev/sda";
    };

    networking = {
      networkmanager.enable = true;
      # tailscale.enable = true;
    };

    programs = {
      bash.enable = true;
    };
  };
}
