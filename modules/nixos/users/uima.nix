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

      # NOTE:
      # ┃ trace: evaluation warning: The user 'uima' has multiple of the options
      # ┃ `hashedPassword`, `password`, `hashedPasswordFile`, `initialPassword`
      # ┃ & `initialHashedPassword` set to a non-null value.
      # ┃ The options silently discard others by the order of precedence
      # ┃ given above which can lead to surprising results. To resolve this warning,
      # ┃ set at most one of the options above to a non-`null` value.
      (mkIf imper.enable {
        initialPassword = "password";
        hashedPasswordFile = "${imper.persist_dir}/passwords/${username}";
      })
    ];

    home-manager.users = mkIf cfg.homeManager {
      ${username} = import ../../../users/${username}/${config.networking.hostName};
    };
  };
}
