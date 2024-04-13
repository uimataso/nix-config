{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.myConfig.system.impermanence;
in
{
  options.myConfig.system.impermanence = {
    enable = mkEnableOption "impermanence";

    persist_dir = mkOption {
      type = types.str;
      default = "/persist/home/${config.home.homeDirectory}";
      description = "The directory to store persistent data.";
    };
  };

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  config = mkIf cfg.enable {
    home.persistence.main = {
      persistentStoragePath = cfg.persist_dir;
      allowOther = true;

      directories = [
        "nix"
      ];
    };
  };
}
