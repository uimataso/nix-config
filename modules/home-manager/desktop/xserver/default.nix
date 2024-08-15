{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.uimaConfig.desktop.xserver;
in {
  options.uimaConfig.desktop.xserver = {
    enable = mkEnableOption "Xserver";
  };

  imports = [
    ./dunst.nix
    ./dwm
  ];

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      profilePath = "${config.xdg.dataHome}/x11/xprofile";
      scriptPath = "${config.xdg.dataHome}/x11/xsession";

      initExtra = with pkgs; ''
        ${xcompmgr}/bin/xcompmgr -n &
        ${xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --rate 144.00
        # No screen saver
        ${xorg.xset}/bin/xset s off -dpms
        ${xwallpaper}/bin/xwallpaper --zoom ${config.stylix.image}
      '';
    };

    xresources = {
      path = "${config.xdg.configHome}/x11/xresources";
      properties = {
        "*.font" = "${config.stylix.fonts.monospace.name}";
        "Xft.dpi" = 96;
        "Xft.antialias" = true;
        "Xft.hinting" = true;
        "Xft.rgba" = "rgb";
        "Xft.autohint" = true;
        "Xft.hintstyle" = "hintfull";
        "Xft.lcdfilter" = "lcdfilter";
      };
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
