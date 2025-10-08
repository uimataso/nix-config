{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.system.impermanence;

  # isUser = user: user.group == "users";
  # users = builtins.filter isUser (builtins.attrValues config.users.users);

  users =
    let
      allUsers = config.uimaConfig.users;
      imperUsers = lib.attrsets.filterAttrs (name: opt: opt.enable && opt.homeManager) allUsers;
      usernames = lib.attrsets.mapAttrsToList (name: opt: opt.name) imperUsers;
    in
    map (username: config.users.users.${username}) usernames;

in
{
  options.uimaConfig.system.impermanence = {
    enable = mkEnableOption "Impermanence setup";

    persist_dir = mkOption {
      type = types.str;
      default = "/persist";
      example = "/nix/persistent";
      description = "The directory to store persistent data.";
    };

    files = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [ ];
      example = [ "/etc/passwd" ];
      description = "The files that stored persistently.";
    };

    directories = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [ ];
      example = [ "/var/log" ];
      description = "The directories that stored persistently.";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = map (user: user.name) users;
      example = [ "uima" ];
      description = "Enable users impermanence.";
    };
  };

  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./ephemeral-btrfs.nix
    ./ephemeral-luks-btrfs.nix
  ];

  config = mkIf cfg.enable {
    # Filesystem modifications needed for impermanence
    fileSystems.${cfg.persist_dir}.neededForBoot = true;

    users.mutableUsers = false;

    # Default persistence files
    environment.persistence.main = {
      persistentStoragePath = cfg.persist_dir;
      hideMounts = true;

      directories = cfg.directories ++ [
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/log"
      ];
      files = cfg.files ++ [ "/etc/machine-id" ];

      users = lib.genAttrs cfg.users (
        username:
        let
          homeImper = config.home-manager.users.${username}.uimaConfig.system.impermanence;
        in
        mkIf homeImper.enable {
          directories = homeImper.directories;
          files = homeImper.files;
        }
      );
    };

    # Create persist home directory
    systemd.tmpfiles = {
      rules = map (user: "d ${cfg.persist_dir}/${user.home} 0700 ${user.name} ${user.group} - -") users;
    };
  };
}
