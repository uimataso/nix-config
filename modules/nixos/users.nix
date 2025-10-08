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
    mkOption
    mkDefault
    mkMerge
    types
    ;

  usersCfg = config.uimaConfig.users;
  enabledUsersCfg = lib.attrsets.filterAttrs (name: opt: opt.enable) usersCfg;

  imper = config.uimaConfig.system.impermanence;

  userOpts =
    { name, ... }:
    {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Where or not to enable this user";
        };

        name = mkOption {
          type = types.str;
          default = name;
          description = "Name of this user";
        };

        homeManager = mkOption {
          type = types.bool;
          default = false;
          description = "Enable home-manager for this user.";
        };

        extraGroups = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "The user's auxiliary groups if exist.";
        };
      };
    };
in
{
  options.uimaConfig = {
    users = mkOption {
      type = types.attrsOf (types.submodule userOpts);
    };
  };

  config = {
    nix.settings.trusted-users = lib.attrsets.mapAttrsToList (name: opt: opt.name) enabledUsersCfg;

    users.users =
      let
        ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

        mkUser =
          name: opt:
          mkMerge [
            {
              name = opt.name;
              home = mkDefault "/home/${opt.name}";
              isNormalUser = true;
              shell = pkgs.bashInteractive;
              extraGroups = ifGroupExist opt.extraGroups;
            }

            (mkIf imper.enable {
              # use `mkpasswd` to generate hashed password
              hashedPasswordFile = "${imper.persist_dir}/passwords/${opt.name}";
            })
          ];
      in
      lib.attrsets.mapAttrs mkUser enabledUsersCfg;

    home-manager.users =
      let
        users = lib.attrsets.filterAttrs (name: opt: opt.homeManager) enabledUsersCfg;
        mkHm = name: opt: import "${self}/users/${opt.name}/${config.networking.hostName}";
      in
      lib.attrsets.mapAttrs mkHm users;

    uimaConfig.system.impermanence.users =
      let
        users = lib.attrsets.filterAttrs (name: opt: opt.homeManager) enabledUsersCfg;
      in
      lib.attrsets.mapAttrsToList (name: opt: opt.name) users;
  };
}
