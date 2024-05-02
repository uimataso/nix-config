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
    ./xcompmgr.nix
    ./xrandr.nix
    ./xresources.nix
    ./xsession.nix

    ./dunst.nix
    ./dwm
    ./wallpaper.nix
  ];

  config = mkIf cfg.enable {
    uimaConfig.desktop.xserver = {
      xcompmgr.enable = mkDefault true;
      xrandr.enable = mkDefault true;
      xresources.enable = mkDefault true;
      xsession.enable = mkDefault true;
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

    xsession.initExtra = "xset s off -dpms"; # No screen saver
  };
}
