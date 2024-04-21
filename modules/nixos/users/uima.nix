{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.users.uima;

  username = "uima";
  home = "/home/${username}";

  imper = config.uimaConfig.system.impermanence;
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.uimaConfig.users.${username} = {
    enable = mkEnableOption "User ${username}";

    homeManager = mkOption {
      type = types.bool;
      default = true;
      description = "Enable home-manager for this user.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${username} = mkMerge [
      {
        home = mkDefault home;
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
      }
      (mkIf imper.enable {
        initialPassword = "password";
        hashedPasswordFile = "${imper.persist_dir}/passwords/${username}";
      })
    ];

    # Create persist home directory
    systemd.tmpfiles = mkIf imper.enable {
      rules = [
        "d ${imper.persist_dir}/${home} 0700 ${username} users - -"
      ];
    };

    home-manager.users = mkIf cfg.homeManager {
      ${username} = import ../../../users/${username}/${config.networking.hostName};
    };
  };
}
