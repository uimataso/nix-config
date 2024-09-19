{ config
, lib
, ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.wayland.dunst;
in
{
  options.uimaConfig.desktop.wayland.dunst = {
    enable = mkEnableOption "dunst";
  };

  config = mkIf cfg.enable {
    uimaConfig.desktop.xserver.dunst.enable = true;
  };
}
