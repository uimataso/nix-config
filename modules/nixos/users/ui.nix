{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.users.ui;

  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  ifPersist = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
in
{
  options.myConfig.users.ui = {
    enable = mkEnableOption "User ui";
  };

  config = mkIf cfg.enable {
    users.users.ui = {
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

      # packages = with pkgs; [
      #   home-manager
      # ];
    } // ifPersist {
      initialPassword = "password";
      hashedPasswordFile = "/persist/passwords/ui";
    };
  };
}
