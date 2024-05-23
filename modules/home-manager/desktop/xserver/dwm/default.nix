{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.wm.dwm;

  scheme = config.stylix.base16Scheme;
in
{
  options.uimaConfig.desktop.xserver.wm.dwm = {
    enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    xsession.initExtra = "dwmblocks &";

    home.sessionPath = [ "$HOME/.local/bin/statesbar" ];
    home.file.".local/bin/statesbar".source = ./statusbar;

    xresources.properties = with config.stylix.fonts; {
      "dwm.font" = "${monospace.name}";
      "dwm.font2" = "${sansSerif.name}";
      "dwm.primary" = "#${scheme.base0E}";
      "dwm.bgaltcolor" = "#${scheme.base02}";
      "dwm.fgaltcolor" = "#${scheme.base03}";
      "dwm.gappx" = 5;
      "dwm.showbar" = 1;
    };
  };
}
