{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.users.ui;

  username = "ui";
  home = "/home/${username}";

  imper = config.uimaConfig.system.impermanence;
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.uimaConfig.users.${username} = {
    enable = mkEnableOption "User ${username}";
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

    systemd.tmpfiles = mkIf imper.enable {
      rules = [
        "d ${imper.persist_dir}/${home} 0700 ${username} users - -"
      ];
    };
  };
}
