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

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = let
        modules = {
          keyboard-state = {
            numlock = true;
            capslock = true;
            format = "{name} {icon}";
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };

          mpd = {
            format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
            format-disconnected = "Disconnected ";
            format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            unknown-tag = "N/A";
            interval = 5;
            consume-icons = {
              on = " ";
            };
            random-icons = {
              off = "<span color=\"#f53c3c\"></span> ";
              on = " ";
            };
            repeat-icons = {
              on = " ";
            };
            single-icons = {
              on = "1 ";
            };
            state-icons = {
              paused = "";
              playing = "";
            };
            tooltip-format = "MPD (connected)";
            tooltip-format-disconnected = "MPD (disconnected)";
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          tray = {
            # icon-size = 21;
            spacing = 10;
          };

          clock = {
            # timezone = "America/New_York";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };

          cpu = {
              format = "{usage}% ";
              tooltip = false;
          };

          memory = {
              format = "{}% ";
          };

          temperature = {
            # thermal-zone = 2;
            # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            critical-threshold = 80;
            # format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" ""];
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

          network = {
              # interface = "wlp2*", // (Optional) To force the use of this interface
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
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

          "custom/power" = {
            format = "⏻ ";
            tooltip = false;
            menu = "on-click";
            menu-file = "$HOME/.config/waybar/power_menu.xml"; # Menu file in resources folder
            menu-actions = {
              shutdown = "shutdown";
              reboot = "reboot";
              suspend = "systemctl suspend";
              hibernate = "systemctl hibernate";
            };
          };
        };
      in
      {
        mainBar = modules // {
          height = 16;
          spacing = 16;

          modules-left = [
            "river/tags"
            "river/mode"
            "sway/workspaces"
            "sway/mode"
            "sway/scratchpad"
          ];
          modules-center= [
            "river/window"
            "sway/window"
          ];
          modules-right = [
            "mpd"
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "power-profiles-daemon"
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "keyboard-state"
            "battery"
            "clock"
            "tray"
            "custom/power"
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
          font-family: "${fonts.sansSerif.name}";
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
