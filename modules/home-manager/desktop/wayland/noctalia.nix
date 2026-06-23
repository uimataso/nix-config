{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.uimaConfig.desktop.wayland.noctalia;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.uimaConfig.desktop.wayland.noctalia = {
    enable = mkEnableOption "noctalia";
    package = lib.mkPackageOption pkgs "noctalia-shell" { };
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".local/state/noctalia" ];
    };

    home.sessionVariables = {
      QS_ICON_THEME = "Papirus-Dark";
    };

    home.packages = with pkgs; [ papirus-icon-theme ];

    programs.noctalia = {
      enable = true;

      settings = {
        theme = {
          custom_palette = "stylix";
          source = "custom";
        };

        shell = {
          corner_radius_scale = 0.3;
          font_family = config.stylix.fonts.monospace.name;
          polkit_agent = true;
          settings_show_advanced = true;

          panel = {
            borders = false;
            launcher_categories = false;
            open_near_click_control_center = true;
            session_placement = "centered";
          };
        };

        wallpaper = {
          directory = "/share/nix/modules/nixos/theme/wallpapers";
        };

        bar.default = {
          position = "bottom";
          thickness = 28;
          margin_edge = 0;
          margin_ends = 0;
          padding = 20;
          radius = 0;

          shadow = false;
          background_opacity = config.stylix.opacity.desktop;

          capsule = true;
          capsule_opacity = 0.0; # i just want the padding
          capsule_padding = 3.0;
          capsule_radius = 2;

          end = [
            "privacy"
            "tray"
            "cpu"
            "ram"
            "temp"
            "notifications"
            "volume"
            "bluetooth"
            "network"
            "battery"
            "control-center"
          ];
          center = [ "clock" ];
          start = [
            "workspaces"
            "taskbar"
            "spacer_2"
            "media"
          ];
        };

        widget = {
          clock.font_weight = 700;

          cpu.show_label = false;
          ram.show_label = false;
          temp.show_label = false;
          network.show_label = false;
          volume.show_label = false;

          tray.drawer = true;
          media.hide_when_no_media = true;
          privacy.hide_inactive = true;

          spacer_2.type = "spacer";

          workspaces = {
            display = "none";
            empty_color = "tertiary";
          };
          taskbar = {
            inactive_opacity = 0.7;
            only_active_workspace = true;
            show_active_indicator = false;
          };
        };

        desktop_widgets.enabled = false;
        lockscreen.fingerprint = false;
        lockscreen_widgets.enabled = false;
        location.auto_locate = true;
        weather.effects = false;

        osd = {
          background_opacity = config.stylix.opacity.popups;
          kinds = {
            media = false;
          };
        };
      };

      customPalettes = {
        stylix =
          let
            colors = config.lib.stylix.colors.withHashtag;
          in
          {
            dark = {
              mPrimary = colors.base05;
              mOnPrimary = colors.base00;
              mSecondary = colors.base04;
              mOnSecondary = colors.base00;
              mTertiary = colors.base02;
              mOnTertiary = colors.base05;
              mError = colors.base08;
              mOnError = colors.base00;
              mSurface = colors.base00;
              mOnSurface = colors.base05;
              mSurfaceVariant = colors.base01;
              mOnSurfaceVariant = colors.base05;
              mOutline = colors.base02;
              mShadow = colors.base00;
              mHover = colors.base02;
              mOnHover = colors.base05;
              terminal = {
                background = colors.base00;
                foreground = colors.base05;
                cursor = colors.base05;
                cursorText = colors.base00;
                selectionBg = colors.base02;
                selectionFg = colors.base05;
                normal = {
                  black = colors.base00;
                  red = colors.base08;
                  green = colors.base0B;
                  yellow = colors.base0A;
                  blue = colors.base0D;
                  magenta = colors.base0E;
                  cyan = colors.base0C;
                  white = colors.base05;
                };
                bright = {
                  black = colors.base02;
                  red = colors.base08;
                  green = colors.base0B;
                  yellow = colors.base0A;
                  blue = colors.base0D;
                  magenta = colors.base0E;
                  cyan = colors.base0C;
                  white = colors.base07;
                };
              };
            };
          };
      };
    };
  };
}
