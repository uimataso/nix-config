{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.users.ui;

  username = "ui";

  imper = config.myConfig.system.impermanence;
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  ifImpermanence = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
in
{
  options.myConfig.users.${username} = {
    enable = mkEnableOption "User ${username}";

    home = mkOption {
      type = types.str;
      default = "/home/${username}";
      description = "Home directory for this user.";
    };
  };

  config = mkIf cfg.enable rec {
    users.users.${username} = {
      home = mkDefault cfg.home;
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
      hashedPasswordFile = "${imper.persist_dir}/passwords/${username}";
    };

    systemd.tmpfiles = ifImpermanence {
      rules = [
        "d ${imper.persist_dir}/${cfg.home} 0700 ${username} users - -"
      ];
    };
  };
}
