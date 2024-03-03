{ config, pkgs, ... }:

let
  setWallpaperCmd = "${pkgs.xwallpaper}/bin/xwallpaper --screen 0 --zoom ${config.xdg.dataHome}/wallpaper.png";
in
{
  home.packages = [ pkgs.xwallpaper ];

  xsession.initExtraList = [
    setWallpaperCmd
  ];

  home.file."${config.xdg.dataHome}/wallpaper.png" = {
    source = ../../theme/wallpaper.png;
    # onChange = ''
    #   ${setWallpaperCmd}
    # '';
  };
}
