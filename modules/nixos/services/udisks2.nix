{ config, lib, ... }:
# For users/udiskie to work
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.udisks2;
in
{
  options.uimaConfig.services.udisks2 = {
    enable = mkEnableOption "udisks2";
  };

  config = mkIf cfg.enable {
    services.udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
  };
}
