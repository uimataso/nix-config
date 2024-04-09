{ config, lib, ... }:

# For users/udiskie to work

with lib;

let
  cfg = config.myConfig.services.udisks2;
in
{
  options.myConfig.services.udisks2 = {
    enable = mkEnableOption "udisks2";
  };

  config = mkIf cfg.enable {
    services.udisks2.enable = true;
  };
}
