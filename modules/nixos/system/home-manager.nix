{ config, lib, pkgs, pkgs-unstable, inputs, outputs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.home-manager;
in
{
  options.uimaConfig.system.home-manager = {
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
        inherit inputs outputs pkgs-unstable;
      };

      users = attrsets.genAttrs cfg.users (username: import
        ../../../users/${username}/${config.networking.hostName});
    };
  };
}
