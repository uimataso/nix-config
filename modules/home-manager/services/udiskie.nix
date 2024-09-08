{ config, lib, ... }:
# Need hosts/udisks2 to work
with lib;
let
  cfg = config.uimaConfig.services.udiskie;
in
{
  options.uimaConfig.services.udiskie = {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable { services.udiskie.enable = true; };
}
