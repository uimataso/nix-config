{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.system.doas;
in
{
  options.uimaConfig.system.doas = {
    enable = mkEnableOption "doas";

    disableSudo = mkOption {
      type = types.bool;
      default = false;
      description = "Disable sudo";
    };
  };

  config = mkIf cfg.enable {
    security.sudo.enable = mkDefault (!cfg.disableSudo);

    security.doas = {
      enable = true;

      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };
}
