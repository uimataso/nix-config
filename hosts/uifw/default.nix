{ inputs, ... }:

# sudo -i
# flake_url='github:uimataso/nix-config#uifw'
# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# nixos-install --flake "$flake_url" --no-root-passwd
# chown uima:users /mnt/persist/passwords/uima

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  system.stateVersion = "23.11";

  networking.hostName = "uifw";
  time.timeZone = "Asia/Taipei";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    # timeoutStyle = "hidden";
  };

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      sudo.enable = true;
      autoUpgrade.enable = true;

      impermanence = {
        enable = true;
        luksBtrfs.enable = true;
        luksBtrfs.device = "/dev/nvme0n1";
        users = [ "uima" ];
      };
    };

    desktop = {
      wayland = {
        river.enable = true;
      };
    };

    networking = {
      networkmanager.enable = true;
      tailscale.enable = true;
    };

    hardware = {
      pipewire.enable = true;
      bluetooth.enable = true;
    };

    services = {
      udisks2.enable = true;
    };

    virt = {
      vm.enable = true;
      docker.enable = true;
    };
  };
}
