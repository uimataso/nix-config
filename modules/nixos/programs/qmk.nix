{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.programs.qmk;
in
{
  options.uimaConfig.programs.qmk = {
    enable = mkEnableOption "QMK keyboard firmware";
  };

  config = mkIf cfg.enable { hardware.keyboard.qmk.enable = true; };
}
