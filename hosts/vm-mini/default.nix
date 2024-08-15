{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
# sudo -i
# flake_url='github:uimataso/nix-config#vm-mini'
# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# nixos-install --flake "$flake_url" --no-root-passwd
# chown ui:users /mnt/persist/passwords/ui
{
  imports = [./hardware-configuration.nix];

  system.stateVersion = "23.11";

  networking.hostName = "vm-mini";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    boot.grub.enable = true;

    system = {
      sops.enable = true;
      sudo.enable = true;
      auto-upgrade.enable = true;

      impermanence.enable = true;
      impermanence.btrfs.enable = true;
      impermanence.btrfs.device = "/dev/vda";

      pipewire.enable = true;
      udisks2.enable = true;
    };

    desktop.xserver = {
      enable = true;
      dwm.enable = true;
      sddm.enable = true;
    };

    networking = {
      networkmanager.enable = true;
      tailscale.enable = true;
    };

    programs = {
      bash.enable = true;
    };
  };
}
