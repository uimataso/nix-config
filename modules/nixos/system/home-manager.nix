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
      example = [ "uima" ];
      description = ''
        List of users to enable home-manager.
        This module will auto load the home-manager module from ./users/{username}/{hostname}.
      '';
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # TODO: enable option is needed?
  config = mkIf cfg.enable {
    # TODO: import home-manager here or in flake.nix?
    # define home-manager in flake.nix then import from outputs?
    home-manager = {
      sharedModules = [ outputs.homeManagerModules ];
      extraSpecialArgs = {
        inherit inputs outputs pkgs-unstable;
      };

      users = attrsets.genAttrs cfg.users (username: import
        ../../../users/${username}/${config.networking.hostName});
    };
  };
}
