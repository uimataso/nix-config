{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.wayland.waybar;
in
{
  options.uimaConfig.desktop.wayland.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    stylix.targets.waybar.enable = false;

    programs.waybar = with config.lib.stylix.colors.withHashtag; {
      enable = true;
      systemd.enable = true;

      settings = let
        modules = {
          clock = {
            format = "{:%a %b %d  %H:%M} ";
            tooltip-format = "{calendar}";
            calendar = {
              mode = "year";
              weeks-pos = "right";
              mode-mon-col = 3;
              on-scroll = 1;
              format = {
                months   = "<span color='${base0A}'><b>{}</b></span>";
                days     = "<span color='${base05}'><b>{}</b></span>";
                weeks    = "<span color='${base0C}'><b>W{}</b></span>";
                weekdays = "<span color='${base09}'><b>{}</b></span>";
                today    = "<span color='${base08}'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          tray = {
            # icon-size = 21;
            spacing = 10;
          };

          cpu = {
              format = "{usage}% ";
              tooltip = false;
          };

          memory = {
              format = "{}% ";
          };

          backlight = {
              # "device" = "acpi_video1";
              format = "{percent}% {icon}";
              format-icons = ["" "" "" "" "" "" "" "" ""];
          };

          battery = {
              states = {
                  # good = 95;
                  warning = 30;
                  critical = 15;
              };
              format = "{capacity}% {icon}";
              format-full = "{capacity}% {icon}";
              format-charging = "{capacity}% ";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              # format-good = "", // An empty format will hide the module
              # format-full = "";
              format-icons = ["" "" "" "" ""];
          };

          power-profiles-daemon = {
            format = "{icon}";
            tooltip-format = "Power profile: {profile}\nDriver: {driver}";
            tooltip = true;
            format-icons = {
              default = "";
              performance = "";
              balanced = "";
              power-saver = "";
            };
          };

          pulseaudio = {
              # scroll-step = 1, // %, can be a float
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = " {format_source}";
              format-source = "{volume}% ";
              format-source-muted = "";
              format-icons = {
                  headphone = "";
                  hands-free = "";
                  headset = "";
                  phone = "";
                  portable = "";
                  car = "";
                  default = ["" "" ""];
              };
              on-click = "pavucontrol";
          };

          network = {
              # interface = "wlp2*", // (Optional) To force the use of this interface
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
          };

          "river/window" = {
            max-length = 80;
            tooltip = false;
          };
        };
      in
      {
        mainBar = modules // {
          height = 16;
          spacing = 16;

          modules-left = [
            "river/tags"
            # "river/mode"
            "sway/workspaces"
            "sway/mode"
            "sway/scratchpad"
          ];
          modules-center= [
            "river/window"
            "sway/window"
          ];
          modules-right = [
            "tray"

            "pulseaudio"

            "cpu"
            "memory"
            "backlight"

            "network"
            "battery"

            "clock"
          ];
        };
      };

      style =
        with config.lib.stylix.colors.withHashtag;
        with config.stylix;
        # css
        ''
        @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
        @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

        @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
        @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

        * {
          font-family: "${fonts.monospace.name}";
          font-size: ${builtins.toString fonts.sizes.desktop}pt;
        }

        window#waybar, tooltip {
          background: alpha(@base00, ${builtins.toString opacity.desktop});
          color: @base05;
        }

        tooltip {
          border-color: @base0D;
        }
      '';
    };
  };
}
