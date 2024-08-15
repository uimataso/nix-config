{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.uimaConfig.system.impermanence;

  isUser = user: user.group == "users";
  users = builtins.filter isUser (builtins.attrValues config.users.users);
in {
  options.uimaConfig.system.impermanence = {
    enable = mkEnableOption "Impermanence setup";

    persist_dir = mkOption {
      type = types.str;
      default = "/persist";
      example = "/nix/persistent";
      description = "The directory to store persistent data.";
    };
  };

  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./ephemeral-btrfs.nix
  ];

  config = mkIf cfg.enable {
    # Filesystem modifications needed for impermanence
    fileSystems.${cfg.persist_dir}.neededForBoot = true;

    programs.fuse.userAllowOther = true;
    users.mutableUsers = false;

    # Default persistence files
    environment.persistence.main = {
      persistentStoragePath = cfg.persist_dir;
      hideMounts = true;

      directories = [
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/log"
      ];
      files = ["/etc/machine-id"];
    };

    # Create persist home directory
    systemd.tmpfiles = {
      rules = map (user: "d ${cfg.persist_dir}/${user.home} 0700 ${user.name} ${user.group} - -") users;
    };
  };
}
