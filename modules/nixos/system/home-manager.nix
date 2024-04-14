{ config, lib, pkgs, inputs, outputs, ... }:

with lib;

let
  cfg = config.myConfig.system.home-manager;
in
{
  options.myConfig.system.home-manager = {
    enable = mkEnableOption "Home Manager";

    users = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "ui" ];
      description = "Users to enable home-manager.";
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = mkIf cfg.enable {
    home-manager = {
      sharedModules = [ ../../home-manager ];
      extraSpecialArgs = {
        inherit inputs outputs;
      };

      users = attrsets.genAttrs cfg.users (username: import
        ../../../users/${username}/${config.networking.hostName});
    };
  };
}
