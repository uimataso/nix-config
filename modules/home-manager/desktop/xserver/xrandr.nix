{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver.xrandr;
in
{
  options.myConfig.desktop.xserver.xrandr = {
    enable = mkEnableOption "Xrandr";
    # TODO: option to setup monitor
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xorg.xrandr
    ];

    myConfig.desktop.xserver.xsession.initExtraList = [
      "xrandr --output HDMI-0 --mode 1920x1080 --rate 144.00"
    ];
  };
}
