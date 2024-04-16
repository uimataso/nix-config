{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.users.ui;

  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  ifImpermanence = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
in
{
  options.myConfig.users.ui = {
    enable = mkEnableOption "User ui";
  };

  config = mkIf cfg.enable rec {
    users.users.ui = {
      home = mkDefault "/home/ui";
      isNormalUser = true;
      shell = pkgs.bashInteractive;

      extraGroups = [
        "wheel"
      ] ++ ifGroupExist [
        "networkmanager"
        "docker"
        "podman"
        "libvirtd"
      ];
    } // ifImpermanence {
      initialPassword = "password";
      hashedPasswordFile = "/persist/passwords/ui";
    };

    environment.persistence.main = ifImpermanence {
      users.ui.home = users.users.ui.home;
    };
  };
}
