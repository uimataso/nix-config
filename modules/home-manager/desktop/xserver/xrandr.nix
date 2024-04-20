{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.xrandr;
in
{
  options.uimaConfig.desktop.xserver.xrandr = {
    enable = mkEnableOption "Xrandr";
    # TODO: how proper setup monitor
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xorg.xrandr
    ];

    xsession.initExtra = "xrandr --output HDMI-0 --mode 1920x1080 --rate 144.00";
  };
}
