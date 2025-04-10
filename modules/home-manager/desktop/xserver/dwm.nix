{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.desktop.xserver.dwm;
in
{
  options.uimaConfig.desktop.xserver.dwm = {
    enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    uimaConfig.desktop.xserver.enable = true;

    xresources.properties =
      with config.lib.stylix.colors.withHashtag;
      with config.stylix.fonts;
      {
        "dwm.font" = monospace.name;
        "dwm.font2" = sansSerif.name;
        "dwm.primary" = base0E;
        "dwm.bgaltcolor" = base02;
        "dwm.fgaltcolor" = base03;
        "dwm.gappx" = 5;
        "dwm.showbar" = 1;
      };
  };
}
