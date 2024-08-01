{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "23.11";

  networking.hostName = "araizen";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      wsl = {
        enable = true;
        docker = true;
      };

      sudo.enable = true;
      auto-upgrade.enable = true;
    };

    networking.networkmanager.enable = true;
    programs.bash.enable = true;
  };

  # For Home-Manager
  # TODO: Why do I need this?
  programs.dconf.enable = true;
}
