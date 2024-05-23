{ config, lib, ... }:

with lib;

# TODO: no tablets are detected

let
  cfg = config.uimaConfig.hardware.otd;
in
{
  options.uimaConfig.hardware.otd = {
    enable = mkEnableOption "open tablet driver";
  };

  config = mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
  };
}
