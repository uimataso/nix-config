{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.dunst;

  scheme = config.scheme;
in
{
  options.uimaConfig.desktop.xserver.dunst = {
    enable = mkEnableOption "dunst";
  };

  config = {
    home.packages = with pkgs; [
      libnotify
    ];

    services.dunst = {
      enable = true;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };

      settings = {
        global = {
          monitor = 0;
          follow = "keyboard";
          width = "(0, 300)";
          height = 300;
          origin = "top-right";
          offset = "20x35";
          transparency = 0;
          padding = 12;
          horizontal_padding = 12;
          text_icon_padding = 0;
          frame_width = 0;
          frame_color = "#${scheme.base06}";
          gap_size = 4;

          font = "Monospace 11";
          line_height = 1;

          enable_recursive_icon_lookup = true;
        };

        urgency_low = {
          background = "#${scheme.base02}";
          foreground = "#${scheme.base07}";
          timeout = 5;
        };

        urgency_normal = {
          background = "#${scheme.base03}";
          foreground = "#${scheme.base07}";
          timeout = 5;
        };

        urgency_critical = {
          background = "#${scheme.base08}";
          foreground = "#${scheme.base06}";
          timeout = 0;
        };
      };
    };
  };
}
