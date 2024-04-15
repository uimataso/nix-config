{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver;
in
{
  options.myConfig.desktop.xserver = {
    enable = mkEnableOption "Xserver";
  };

  imports = [
    ./xsession.nix
    ./xresources.nix
    ./xrandr.nix
    ./xcompmgr.nix

    ./wallpaper.nix
    ./dunst.nix
    ./dwm
  ];

  config = mkIf cfg.enable {
    myConfig.desktop.xserver = {
      xresources.enable = mkDefault true;
      xsession.enable = mkDefault true;
      xrandr.enable = mkDefault true;
      xcompmgr.enable = mkDefault true;
    };

    # Hide mouse cursor
    services.unclutter.enable = true;

    home.packages = with pkgs; [
      xclip
    ];

    myConfig.desktop.xserver.xsession.initExtraList = [
      "xset s off -dpms"  # No screen saver
    ];

  };
}
