{ config, lib, ... }:
# TODO: no tablets are detected
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.hardware.otd;
in
{
  options.uimaConfig.hardware.otd = {
    enable = mkEnableOption "open tablet driver";
  };

  config = mkIf cfg.enable { hardware.opentabletdriver.enable = true; };
}
