{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "23.11";

  # Since this mechine is under WSL
  wsl = {
    enable = true;
    defaultUser = "uima";
    docker-desktop.enable = true;
  };

  # Manual start dockerd
  # TODO: Figure out a better other way to do this, but, this works :)
  system.activationScripts = {
    startDocker.text = ''
      nohup ${pkgs.docker}/bin/dockerd > /tmp/docker.log 2> /tmp/docker.err.log &
    '';
  };

  # For Home-Manager
  # TODO: Move to global?
  programs.dconf.enable = true;

  networking.hostName = "araizen";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      sudo.enable = true;
      auto-upgrade.enable = true;
    };

    networking.networkmanager.enable = true;
    programs.bash.enable = true;
  };
}
