{ config, lib, pkgs, ... }:

with lib;

# TODO: wayland solution
# TODO: hot switch wallpaper when switch

let
  cfg = config.uimaConfig.desktop.xserver.wallpaper;

  setWallpaperCmd = "${pkgs.xwallpaper}/bin/xwallpaper --screen 0 --zoom ${config.xdg.dataHome}/wallpaper.png";
in
{
  options.uimaConfig.desktop.xserver.wallpaper = {
    enable = mkEnableOption "Wallpaper";

    imgPath = mkOption {
      type = types.path;
      default = ./wallpaper.png;
      description = "Wallpaper image path.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.xwallpaper ];

    xsession.initExtra = setWallpaperCmd;

    home.file."${config.xdg.dataHome}/wallpaper.png" = {
      source = cfg.imgPath;
      # onChange = ''
      #   ${setWallpaperCmd}
      # '';
    };
  };
}
