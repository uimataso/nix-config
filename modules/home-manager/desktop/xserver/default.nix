{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver;
in {
  options.myConfig.desktop.xserver = {
    enable = mkEnableOption "Xserver";
  };

  imports = [
    ./xsession.nix
    ./xresources.nix
    ./wallpaper.nix
    ./dunst.nix

    ./dwm
  ];

  config = mkIf cfg.enable {
    myConfig.desktop.xserver = {
      xresources.enable = mkDefault true;
      xsession.enable = mkDefault true;
    };

    home.packages = with pkgs; [
      xcompmgr
      xclip
      xorg.xrandr
    ];

    # TODO: make this module
    myConfig.desktop.xserver.xsession.initExtraList = [
      "xcompmgr -n &"
      "xrandr --output HDMI-0 --mode 1920x1080 --rate 144.00"
      "xset s off -dpms"
    ];

    services.unclutter.enable = true;
  };
}
