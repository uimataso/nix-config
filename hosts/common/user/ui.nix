{ config, pkgs, ... }:

let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in{
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
}
