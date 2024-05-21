{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver;
in
{
  options.uimaConfig.desktop.xserver = {
    enable = mkEnableOption "Xserver";
  };

  imports = [
    ./xresources.nix
    ./dunst.nix
    ./dwm
  ];

  config = mkIf cfg.enable {
    uimaConfig.desktop.xserver = {
      xresources.enable = mkDefault true;
    };

    xsession = {
      enable = true;
      profilePath = "${config.xdg.dataHome}/x11/xprofile";
      scriptPath = "${config.xdg.dataHome}/x11/xsession";

      initExtra = with pkgs; ''
        ${xcompmgr}/bin/xcompmgr -n &
        ${xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --rate 144.00
        # No screen saver
        ${xorg.xset}/bin/xset s off -dpms
      '';

    };

    # Hide mouse cursor
    services.unclutter.enable = true;

    home.packages = with pkgs; [
      xclip

      scripts.app-launcher
      scripts.open
      scripts.power-menu
      scripts.screenshot
      scripts.swallower
    ];
  };
}
