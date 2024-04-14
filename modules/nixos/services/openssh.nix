{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.services.openssh;
  ifImpermanence = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
in
{
  options.myConfig.services.openssh = {
    enable = mkEnableOption "openssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
      };
    };

    # TODO: how to manage key then?
    environment.persistence.main = ifImpermanence { };
  };
}
