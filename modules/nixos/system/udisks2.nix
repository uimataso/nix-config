{ config, lib, ... }:

# For users/udiskie to work

with lib;

let
  cfg = config.uimaConfig.system.udisks2;
in
{
  options.uimaConfig.system.udisks2 = {
    enable = mkEnableOption "udisks2";
  };

  config = mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
