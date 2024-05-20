{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.xresources;

  scheme = config.stylix.base16Scheme;

  bg = "#${scheme.base00}";
  fg = "#${scheme.base07}";
  accent = "#${scheme.base0E}";

  font = "MesloLGS Nerd Font";
in
{
  options.uimaConfig.desktop.xserver.xresources = {
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
      "dwm.bgaltcolor" = "#${scheme.base02}";
      "dwm.fgaltcolor" = "#${scheme.base03}";
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

      # "*color0" = "#${scheme.base00}";
      # "*color1" = "#${scheme.base08}";
      # "*color2" = "#${scheme.base0B}";
      # "*color3" = "#${scheme.base0A}";
      # "*color4" = "#${scheme.base0D}";
      # "*color5" = "#${scheme.base0E}";
      # "*color6" = "#${scheme.base0C}";
      # "*color7" = "#${scheme.base05}";
      #
      # "*color8" = "#${scheme.base03}";
      # "*color9" = "#${scheme.base08}";
      # "*color10" = "#${scheme.base0B}";
      # "*color11" = "#${scheme.base0A}";
      # "*color12" = "#${scheme.base0D}";
      # "*color13" = "#${scheme.base0E}";
      # "*color14" = "#${scheme.base0C}";
      # "*color15" = "#${scheme.base07}";
    };
  };
}
