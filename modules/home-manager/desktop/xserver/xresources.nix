{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.xresources;

  scheme = config.stylix.base16Scheme;
in
{
  options.uimaConfig.desktop.xserver.xresources = {
    enable = mkEnableOption "Xresources";
  };

  config = mkIf cfg.enable {
    xresources.path = "${config.xdg.configHome}/x11/xresources";

    # xsession.initExtra = "[ -f ${config.xresources.path} ] && xrdb -merge ${config.xresources.path}";

    xresources.properties = {
      "*.font" = "MesloLGS Nerd Font";
      "*.font2" = "Noto Sans CJK TC";
      "*.alpha" = "0.90";

      "picom.corner_radius" = 0;
      "picom.transition_length" = 0;
      "picom.inactive_dim" = 0;
      "picom.inactive_opacity" = 1;

      "dwm.primary" = "#${scheme.base0E}";
      "dwm.bgaltcolor" = "#${scheme.base02}";
      "dwm.fgaltcolor" = "#${scheme.base03}";
      "dwm.gappx" = 5;
      "dwm.showbar" = 1;

      "st.font" = "MesloLGS Nerd Font:size=11";
      "st.cursorColor" = "#${scheme.base05}";
      "st.cwscale" = "0.95";
      "st.shell" = "/bin/bash";

      "Xft.dpi" = 96;
      "Xft.antialias" = true;
      "Xft.hinting" = true;
      "Xft.rgba" = "rgb";
      "Xft.autohint" = true;
      "Xft.hintstyle" = "hintfull";
      "Xft.lcdfilter" = "lcdfilter";
    };
  };
}
