{
  config,
  pkgs,
  ...
}:
{
  stylix.targets.waybar.enable = false;

  programs.waybar = with config.lib.stylix.colors.withHashtag; {
    enable = true;
    systemd.enable = true;

    settings =
      let
        withColor = color: text: "<span color='${color}'>${text}</span>";
        withColorGray = withColor base03;

        modules = {
          clock = {
            interval = 10;
            format = "{:%a %b %d  %H:%M} ";
            tooltip-format = "{calendar}";
            calendar = {
              mode = "year";
              weeks-pos = "right";
              mode-mon-col = 3;
              on-scroll = 1;
              format = {
                months = withColor base0A "<b>{}</b>";
                days = withColor base05 "<b>{}</b>";
                weeks = withColor base0C "<b>W{}</b>";
                weekdays = withColor base09 "<b>{}</b>";
                today = withColor base08 "<b><u>{}</u></b>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

          # TODO: when I need this
          battery = { };

          network =
            let
              tooltip-format = "{ifname} ${withColorGray "via"} {gwaddr} ${withColorGray "at"} {ipaddr}/{cidr}";
            in
            {
              interval = 10;
              format-ethernet = "󰛳 ";
              format-wifi = "󰖩 {icon}";
              format-linked = "󰲝 ";
              format-disconnected = "󰲜 ";
              format-icons = [
                "󰣾"
                "󰣴"
                "󰣶"
                "󰣸"
                "󰣺"
              ];

              inherit tooltip-format;
              tooltip-format-wifi = "{essid} ${withColorGray "at"} {signalStrength}% ${withColorGray "on"} {frequency}G  ${tooltip-format}";
            };

          "network#bandwidth" = {
            interval = 1;
            # icon: nf-oct-arrow_up
            format = "{bandwidthDownBytes:>16} {bandwidthUpBytes:>16} ";
            tooltip = false;
          };

          pulseaudio =
            let
              pactl = "${pkgs.pulseaudio}/bin/pactl";

              pulseaudioSwitchSink =
                pkgs.writeShellScript "pulseaudio-switch-sink" # sh
                  ''
                    PATH="${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin/:${pkgs.findutils}/bin"

                    def=$(${pactl} get-default-sink)
                    ${pactl} list short sinks |
                      cut -f2 |
                      grep -v easyeffects_sink |
                      tr '\n' ' ' |
                      sed "s/^.*$def \(\S*\) .*/\1/" | # look for next sink
                      sed "s/^\(\S*\) .*/\1/" | # if $def is last, look for first
                      xargs ${pactl} set-default-sink
                  '';
            in
            {
              scroll-step = 1.0;
              max-volume = 120;

              format = "{icon} {format_source}";
              format-muted = "  {format_source}";
              format-bluetooth = "{icon} {format_source}";
              format-bluetooth-muted = "  {format_source}";
              format-source = "";
              format-source-muted = "";
              format-icons = {
                default = [
                  " "
                  " "
                  " "
                ];
                headphone = " ";
                "alsa_output.pci-0000_00_1f.3.analog-stereo" = " ";
                "alsa_output.pci-0000_00_1f.3.iec958-stereo" = " ";
                "bluez_output.04_57_91_F0_A1_EA.1" = "󱡏";
              };

              tooltip-format = "{volume}%  {desc}";

              on-click = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
              on-click-right = "${pulseaudioSwitchSink} 2> /tmp/output";

              ignored-sinks = [ "Easy Effects Sink" ];
            };

          bluetooth = {
            format = "";
            format-disabled = ""; # an empty format will hide the module
            format-off = "󰂲";
            format-on = "<sub>0</sub>";
            format-connected = "<sub>{num_connections}</sub>";
            format-connected-battery = "<sub>{num_connections}</sub> 󰥄 {device_battery_percentage}%";

            tooltip-format = "{controller_alias}: {controller_address_type} {controller_address}";
            tooltip-format-connected = "{controller_alias}: {controller_address_type} {controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}:\t{device_address_type} {device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias} {device_battery_percentage:3}%:\t{device_address_type} {device_address}";
          };

          cpu = {
            interval = 10;
            format = " {usage:2}%";
            tooltip = false;
          };

          memory = {
            interval = 10;
            # format = " {used:2.1f}/{total:2.1f}G";
            format = " {percentage}%";
            tooltip-format = "{used:0.1f}GiB of {total:0.1f}GiB used";
          };

          # TODO: when i need this
          backlight = {
            format = "{icon} ";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };

          privacy =
            let
              icon-size = 16;
            in
            {
              icon-spacing = 8;
              icon-size = icon-size;
              transition-duration = 250;
              modules = [
                {
                  type = "screenshare";
                  tooltip = true;
                  tooltip-icon-size = icon-size;
                }
                {
                  type = "audio-out";
                  tooltip = true;
                  tooltip-icon-size = icon-size;
                }
                {
                  type = "audio-in";
                  tooltip = true;
                  tooltip-icon-size = icon-size;
                }
              ];
            };

          tray = {
            icon-size = 16;
            spacing = 10;
          };

          "river/window" = {
            max-length = 80;
            tooltip = false;
          };
        };
      in
      {
        mainBar = modules // {
          height = 18;
          spacing = 16;

          modules-left = [
            "river/tags"
            # "river/mode"
            "sway/workspaces"
            "sway/mode"
            "sway/scratchpad"
            "tray"
            "systemd-failed-units"
          ];
          modules-center = [
            "river/window"
            "sway/window"
          ];
          modules-right = [
            "privacy"
            "network#bandwidth"

            "cpu"
            "memory"
            "backlight"

            "bluetooth"
            "pulseaudio"

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
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar, tooltip {
          background: alpha(@base00, ${builtins.toString opacity.desktop});
          color: @base05;
        }

        tooltip {
          border-color: @base0D;
        }

        #tags button {
          color: @base03;
        }
        #tags button.occupied {
          color: @base05;
          background: @base00;
        }
        #tags button.focused {
          color: @base00;
          background: @base05;
        }
        #tags button.urgent {
          color: @base08;
        }
      '';
  };
}
