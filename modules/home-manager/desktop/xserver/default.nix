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
    ./xsession.nix
    ./xresources.nix
    ./xrandr.nix
    ./xcompmgr.nix

    ./wallpaper.nix
    ./dunst.nix
    ./dwm
  ];

  config = mkIf cfg.enable {
    uimaConfig.desktop.xserver = {
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

    xsession.initExtra = "xset s off -dpms";  # No screen saver
  };
}
