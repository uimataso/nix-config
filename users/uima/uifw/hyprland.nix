{
  config,
  pkgs,
  lib,
  ...
}:
let
  scratchpad = import ./scratchpad.nix;

  noteScratchpad = scratchpad {
    inherit pkgs;
    name = "note";
    spawnCmd = ''"$TERMINAL" --class scratchpad-note --working-directory ~/notes/ -e $EDITOR index.md'';
    className = "scratchpad-note";
  };
  tempScratchpad = scratchpad {
    inherit pkgs;
    name = "temp";
    spawnCmd = ''"$TERMINAL" --class scratchpad-temp -e $EDITOR /tmp/scratchpad'';
    className = "scratchpad-temp";
  };
  termScratchpad = scratchpad {
    inherit pkgs;
    name = "term";
    spawnCmd = ''"$TERMINAL" --class scratchpad-term'';
    className = "scratchpad-term";
  };
in
{

  home.packages = with pkgs; [
    wl-clipboard

    scripts.power-menu
    scripts.app-launcher
    scripts.screenshot
    scripts.vl
    scripts.bright

    noteScratchpad
    termScratchpad
    tempScratchpad
  ];

  home.shellAliases = {
    hl = "Hyprland";
  };

  services.dunst.settings.global = {
    corner_radius = 5;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings =
      let
        inherit (config.lib.stylix) colors;
        rgb = color: "rgb(${color})";
      in
      {
        general."col.active_border" = lib.mkForce (rgb colors.base05);
        group."col.border_active" = lib.mkForce (rgb colors.base05);
        group.groupbar."col.active" = lib.mkForce (rgb colors.base05);

        exec = [
          "hyprctl setcursor HYPRCURSOR_SIZE 16"
        ];
        exec-once = [
          "hypridle"
        ];

        general = {
          layout = "master";
          gaps_in = 5;
          gaps_out = 5;
        };

        cursor = {
          inactive_timeout = 30;
        };

        input = {
          touchpad = {
            natural_scroll = true;
          };
        };

        decoration = {
          rounding = 5;
          dim_inactive = true;
          dim_strength = 0.2;
        };

        animations = {
          first_launch_animation = false;
          bezier = [
            "easeOutCubic,   0.33, 1, 0.68, 1"
          ];
          animation = [
            "windows,    1, 3, easeOutCubic, slide"
            "layers,     1, 1, easeOutCubic, fade"
            "fade,       1, 3, easeOutCubic"
            "border,     1, 3, easeOutCubic"
            "workspaces, 1, 3, easeOutCubic, slide"
          ];
        };

        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
          "SUPER ALT, mouse:272, resizewindow"
        ];

        bind =
          [
            "SUPER, q, killactive"

            "SUPER, j, layoutmsg, cyclenext"
            "SUPER, k, layoutmsg, cycleprev"
            "SUPER, h, layoutmsg, mfact -0.05"
            "SUPER, l, layoutmsg, mfact +0.05"

            "SUPER, space, layoutmsg, swapwithmaster"

            "SUPER, comma, focusmonitor, -1"
            "SUPER, period, focusmonitor, +1"

            "SUPER, escape, exec, hyprlock"
            "SUPER SHIFT, escape, exec, power-menu"
            "SUPER, return, exec, $TERMINAL"
            "SUPER, o, exec, app-launcher"
            "SUPER, b, exec, $BROWSER"

            "SUPER, n, exec, ${noteScratchpad}/bin/open-ws-note"
            "SUPER SHIFT, n, exec, ${noteScratchpad}/bin/open-note"
            "SUPER, t, exec, ${termScratchpad}/bin/open-ws-term"
            "SUPER SHIFT, t, exec, ${termScratchpad}/bin/open-term"
            "SUPER, s, exec, ${tempScratchpad}/bin/open-ws-temp"
            "SUPER SHIFT, s, exec, ${tempScratchpad}/bin/open-temp"

            ",        Print, exec, screenshot full"
            "Shift,   Print, exec, screenshot cur"
            "Control, Print, exec, screenshot sel"
            ", XF86AudioMute,        exec, vl mute"
            ", XF86AudioLowerVolume, exec, vl down 3"
            ", XF86AudioRaiseVolume, exec, vl up 3"
            ", XF86AudioPrev, exec, notify-send prev"
            ", XF86AudioPlay, exec, notify-send play"
            ", XF86AudioNext, exec, notify-send next"
            ", XF86MonBrightnessDown, exec, brightnessctl set 3%-"
            ", XF86MonBrightnessUp,   exec, brightnessctl set +3%"
          ]
          ++ (
            let
              bindWin = key: ws: [
                "SUPER, ${key}, focusworkspaceoncurrentmonitor, ${ws}"
                "SUPER SHIFT, ${key}, movetoworkspace, ${ws}"
              ];
            in
            (bindWin "1" "1")
            ++ (bindWin "2" "2")
            ++ (bindWin "3" "3")
            ++ (bindWin "4" "4")
            ++ (bindWin "5" "5")
            ++ (bindWin "6" "6")
            ++ (bindWin "7" "7")
            ++ (bindWin "8" "8")
            ++ (bindWin "9" "9")
          );

        monitor =
          let
            mkMonitor =
              m:
              let
                name = m.name;
                resolution = "${builtins.toString m.width}x${builtins.toString m.height}@${builtins.toString m.refreshRate}";
                position = "auto";
                scale = "${builtins.toString m.scale}";
              in
              "${name}, ${resolution}, ${position}, ${scale}";
          in
          builtins.map mkMonitor config.uimaConfig.desktop.monitors;
      };
  };

  # TODO:
  # - no idle when music is playing
  # - stop idle service
  # - fprint from screen off (will unlock but scrren didnt light)
  # - fprint or press key from suspend
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 240; # 4min.
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;

    settings =
      let
        inherit (config.lib.stylix) colors;
        rgb = color: "rgb(${color})";
      in
      {
        auth = {
          "fingerprint:enabled" = true;
        };

        general = {
          hide_cursor = true;
        };

        background = {
          blur_passes = 2;
          brightness = 0.4;
        };

        animation = [
          "fade, 1, 1, linear"
        ];

        label = [
          {
            text = ''cmd[update:1000] date +"%a %b %d"'';
            font_size = 80;
            color = rgb colors.base05;
            font_family = config.stylix.fonts.monospace.name;
            position = "0, 200";
          }
          {
            text = ''cmd[update:1000] date +"%H:%M"'';
            font_size = 175;
            color = rgb colors.base05;
            font_family = config.stylix.fonts.monospace.name;
          }
        ];
      };
  };
}
