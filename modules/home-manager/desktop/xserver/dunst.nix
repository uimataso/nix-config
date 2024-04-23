{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.dunst;

  palette = config.colorScheme.palette;
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
          # TODO: theme support
          frame_color = "#aaaaaa";
          gap_size = 4;

          font = "Monospace 11";
          line_height = 1;

          enable_recursive_icon_lookup = true;
        };

        urgency_low = {
          background = "#262626";
          foreground = "#d0d0d0";
          timeout = 5;
          #default_icon = /path/to/icon;
        };

        urgency_normal = {
          background = "#3a3a3a";
          foreground = "#d0d0d0";
          timeout = 5;
          #default_icon = /path/to/icon;
        };

        urgency_critical = {
          background = "#e67e80";
          foreground = "#d0d0d0";
          timeout = 0;
          #default_icon = /path/to/icon;
        };
      };
    };
  };
}
