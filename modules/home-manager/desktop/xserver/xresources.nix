{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver.xresources;

  palette = config.colorScheme.palette;
  bg = "#${palette.base00}";
  fg = "#${palette.base0F}";
  accent = "#${palette.base05}";

  # TODO: font manage
  font = "MesloLGS Nerd Font";
in
{
  options.myConfig.desktop.xserver.xresources = {
    enable = mkEnableOption "Xresources";
  };

  config = mkIf cfg.enable {
    xresources.path = "${config.xdg.configHome}/x11/xresources";

    # xsession.initExtra = "[ -f ${config.xresources.path} ] && xrdb -merge ${config.xresources.path}";

    xresources.properties = {
      "*.background" = bg;
      "*.foreground" = fg;
      "*.primary" = accent;

      "*.font" = font;
      "*.font2" = "Noto Sans CJK TC";
      "*.alpha" = "0.90";

      "picom.corner_radius" = 0;
      "picom.transition_length" = 0;
      "picom.inactive_dim" = 0;
      "picom.inactive_opacity" = 1;

      "dwm.maincolor" = accent;
      "dwm.bgaltcolor" = "#444444";
      "dwm.fgaltcolor" = "#6c6c6c";
      "dwm.gappx" = 5;
      "dwm.showbar" = 1;

      "dmenu.normfgcolor" = fg;
      "dmenu.normbgcolor" = bg;
      "dmenu.selfgcolor" = bg;
      "dmenu.selbgcolor" = accent;
      "dmenu.baralpha" = "0xe6";

      "st.font" = "${font}:size=11";
      "st.cursorColor" = fg;
      "st.cwscale" = "0.95";
      "st.shell" = "/bin/bash";

      "Xft.dpi" = 96;
      "Xft.antialias" = true;
      "Xft.hinting" = true;
      "Xft.rgba" = "rgb";
      "Xft.autohint" = true;
      "Xft.hintstyle" = "hintfull";
      "Xft.lcdfilter" = "lcdfilter";

      "*.black" = "#${palette.base00}";
      "*.red" = "#${palette.base01}";
      "*.green" = "#${palette.base02}";
      "*.yellow" = "#${palette.base03}";
      "*.blue" = "#${palette.base04}";
      "*.magenta" = "#${palette.base05}";
      "*.cyan" = "#${palette.base06}";
      "*.white" = "#${palette.base07}";

      "*.color0" = "#${palette.base00}";
      "*.color1" = "#${palette.base01}";
      "*.color2" = "#${palette.base02}";
      "*.color3" = "#${palette.base03}";
      "*.color4" = "#${palette.base04}";
      "*.color5" = "#${palette.base05}";
      "*.color6" = "#${palette.base06}";
      "*.color7" = "#${palette.base07}";
      "*.color8" = "#${palette.base08}";
      "*.color9" = "#${palette.base09}";
      "*.color10" = "#${palette.base0A}";
      "*.color11" = "#${palette.base0B}";
      "*.color12" = "#${palette.base0C}";
      "*.color13" = "#${palette.base0D}";
      "*.color14" = "#${palette.base0E}";
      "*.color15" = "#${palette.base0F}";
    };
  };
}
