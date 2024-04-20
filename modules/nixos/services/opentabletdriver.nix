{ config, lib, ... }:

# TODO: no tablets are detected

with lib;

let
  cfg = config.uimaConfig.services.otd;
in
{
  options.uimaConfig.services.otd = {
    enable = mkEnableOption "open tablet driver";
  };

  config = mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
  };
}
