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
    security.doas.enable = true;
    # security.sudo.enable = false;

    security.doas.extraRules = [{
      groups = [ "wheel" ];
      keepEnv = true;
      persist = true;
    }];
  };
}
