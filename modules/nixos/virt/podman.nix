{ config, lib, pkgs, ... }:

# TODO: rootless?
# TODO: docker? lazydocker?

with lib;

let
  cfg = config.myConfig.virt.podman;
in {
  options.myConfig.virt.podman = {
    enable = mkEnableOption "podman";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      podman-compose
    ];

    virtualisation.podman = {
      enable = true;

      # Create a `docker` alias for podman
      dockerCompat = true;
      # virtualisation.podman.dockerSocket.enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;

      # virtualisation.podman.enableNvidia = true;
    };
  };
}
