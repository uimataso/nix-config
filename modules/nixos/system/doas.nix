{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.system.doas;
in
{
  options.uimaConfig.system.doas = {
    enable = mkEnableOption "doas";
  };

  config = mkIf cfg.enable {
    # security.sudo.enable = false;

    security.doas = {
      enable = true;

      extraRules = [{
        groups = [ "wheel" ];
        keepEnv = true;
        persist = true;
      }];
    };
  };
}
