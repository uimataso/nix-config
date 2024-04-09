{ config, lib, ... }:

# TODO: no tablets are detected

with lib;

let
  cfg = config.myConfig.services.otd;
in
{
  options.myConfig.services.otd = {
    enable = mkEnableOption "open tablet driver";
  };

  config = mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
  };
}
