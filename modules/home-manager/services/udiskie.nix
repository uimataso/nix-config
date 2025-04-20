# Need hosts/udisks2 to work
{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.udiskie;
in
{
  options.uimaConfig.services.udiskie = {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie.enable = true;
  };
}
