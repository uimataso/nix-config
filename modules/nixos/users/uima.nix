{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    mkMerge
    types
    ;
  cfg = config.uimaConfig.users.uima;

  username = "uima";

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

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "The user's auxiliary groups if exist.";
    };
  };

  config = mkIf cfg.enable {
    nix.settings.trusted-users = [ username ];

    users.users.${username} = mkMerge [
      {
        home = mkDefault "/home/${username}";
        isNormalUser = true;
        shell = pkgs.bashInteractive;
        extraGroups = ifGroupExist cfg.extraGroups;
      }

      (mkIf imper.enable {
        hashedPasswordFile = "${imper.persist_dir}/passwords/${username}";
      })
    ];

    home-manager.users = mkIf cfg.homeManager {
      ${username} = import "${self}/users/${username}/${config.networking.hostName}";
    };
  };
}
