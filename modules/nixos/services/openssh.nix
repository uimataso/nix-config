{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.services.openssh;

  imper = config.myConfig.system.impermanence;
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
    environment.persistence.main = mkIf imper.enable { };
  };
}
