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
        withColor = color: text : "<span color='${color}'>${text}</span>";

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
                months   = withColor base0A "<b>{}</b>";
                days     = withColor base05 "<b>{}</b>";
                weeks    = withColor base0C "<b>W{}</b>";
                weekdays = withColor base09 "<b>{}</b>";
                today    = withColor base08 "<b><u>{}</u></b>";
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

          network = let
            tooltip-format = "{ifname} ${withColor base03 "via"} {gwaddr} ${withColor base03 "at"} {ipaddr}/{cidr}";
          in {
            interval = 5;
            format-ethernet = "{ipaddr}/{cidr} 󰛳 {icon}";
            format-wifi = "{essid} 󰖩 {icon}";
            format-linked = "{ifname} (No IP) 󰛳 {icon}";
            format-disconnected = "󰲜 ";
            format-icons = ["󰣾" "󰣴" "󰣶" "󰣸" "󰣺"];

            inherit tooltip-format;
            tooltip-format-wifi = "{signalStrength}% ${withColor base03 "at"} {frequency}G  ${tooltip-format}";
          };

          "network#bandwidth" = {
            interval = 1;
            # icon: nf-oct-arrow_up
            format = "{bandwidthDownBytes:>16} {bandwidthUpBytes:>16} ";
            tooltip = false;
          };

          pulseaudio = {
            scroll-step = 5.0;
            max-volume = 120;

            format = "{icon}  {volume:3}% {format_source}";
            format-muted = "  {format_source}";
            format-bluetooth = "{icon}  {volume:3}% {format_source}";
            format-bluetooth-muted = "  {format_source}";
            format-source = "";
            format-source-muted = "";
            format-icons = {
              default = ["" "" ""];
              headphone = "";
              "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            };

            tooltip-format = "{desc}";

            on-click = "vl mute";
            on-click-right = "vl switch";

            ignored-sinks = ["Easy Effects Sink"];
          };

          bluetooth = {
            # controller = "controller1"; # specify the alias of the controller if there are more than 1 on the system
            format = " {status}";
            format-disabled = ""; # an empty format will hide the module
            format-connected = " {num_connections} connected";
            tooltip-format = "{controller_alias}\t{controller_address}";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
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
              format-icons = ["" "" "" "" "" "" "" "" ""];
          };

          privacy = let
            icon-size = 16;
          in{
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
          height = 16;
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
          modules-center= [
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
