{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.users.ui;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.myConfig.users.ui = {
    enable = mkEnableOption "User ui";
  };

  config = mkIf cfg.enable {
    users.users.ui = {
      isNormalUser = true;
      shell = pkgs.bashInteractive;
      extraGroups = [
        "wheel"
      ] ++ ifTheyExist [
        "networkmanager"
        "docker"
        "podman"
        "libvirtd"
      ];
    };
  };
}
