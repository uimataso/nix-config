{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.system.home-manager;
in
{
  options.uimaConfig.system.home-manager = {
    enable = mkEnableOption ''
      Eable Home Manager module.
      You should import home-manager modules though flake, this module only
      import users settings.
    '';

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

  config = mkIf cfg.enable {
    home-manager = {
      users = attrsets.genAttrs cfg.users (username: import
        ../../../users/${username}/${config.networking.hostName});
    };
  };
}
