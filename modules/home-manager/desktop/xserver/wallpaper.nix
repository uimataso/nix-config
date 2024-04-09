{ config, lib, pkgs, ... }:

with lib;

# TODO: wayland solution?
# TODO: hot switch wallpaper when nh

let
  cfg = config.myConfig.desktop.xserver.wallpaper;

  setWallpaperCmd = "${pkgs.xwallpaper}/bin/xwallpaper --screen 0 --zoom ${config.xdg.dataHome}/wallpaper.png";
in
{
  options.myConfig.desktop.xserver.wallpaper = {
    enable = mkEnableOption "Wallpaper";

    imgPath = mkOption {
      type = types.path;
      default = ./wallpaper.png;
      description = "Wallpaper image path.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.xwallpaper ];

    myConfig.desktop.xserver.xsession.initExtraList = [
      setWallpaperCmd
    ];

    home.file."${config.xdg.dataHome}/wallpaper.png" = {
      source = cfg.imgPath;
      # onChange = ''
      #   ${setWallpaperCmd}
      # '';
    };
  };
}
