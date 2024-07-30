{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "23.11";

  # This mechine is under WSL
  wsl = {
    enable = true;
    defaultUser = "uima";
    docker-desktop.enable = true;
  };

  # Manual start dockerd
  # TODO: Figure out other way to do this, but, this worked
  system.activationScripts = {
    startDocker.text = ''
      nohup ${pkgs.docker}/bin/dockerd > /tmp/docker.log 2> /tmp/docker.err.log &
    '';
  };

  # For Home-Manager
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

    # virt = {
    #   docker.enable = true;
    # };
  };
}
