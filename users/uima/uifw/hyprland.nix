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
    spawnCmd = ''"$TERMINAL" --app-id scratchpad-note -e tmux new-session -A -s notes -c /share/notes $EDITOR inbox.md'';
    className = "scratchpad-note";
  };
  tempScratchpad = scratchpad {
    inherit pkgs;
    name = "temp";
    spawnCmd = ''"$TERMINAL" --app-id scratchpad-temp -e $EDITOR /share/scratchpad.md'';
    className = "scratchpad-temp";
  };
  termScratchpad = scratchpad {
    inherit pkgs;
    name = "term";
    spawnCmd = ''"$TERMINAL" --app-id scratchpad-term'';
    className = "scratchpad-term";
  };
  musicScratchpad = scratchpad {
    inherit pkgs;
    name = "music";
    spawnCmd = ''"$TERMINAL" --app-id scratchpad-music -e rmpc'';
    className = "scratchpad-music";
  };

  toggleWaybar = "if systemctl --user is-active --quiet waybar.service; then systemctl --user stop waybar.service; else systemctl --user start waybar.service; fi";

  inherit (config.lib.stylix) colors;
  rgb = color: "rgb(${color})";
in
{
  home.packages = with pkgs; [
    wl-clipboard
    brightnessctl
    playerctl

    scripts.power-menu
    scripts.app-launcher

    scripts.screenshot
    scripts.vl

    noteScratchpad
    termScratchpad
    tempScratchpad
    musicScratchpad
  ];

  home.shellAliases = {
    hl = "Hyprland";
  };

  uimaConfig.sh.bash.execOnTty1 = "Hyprland";

  services.dunst.settings.global = {
    corner_radius = 5;
  };

  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      general."col.active_border" = lib.mkForce (rgb colors.base05);
      group."col.border_active" = lib.mkForce (rgb colors.base05);
      group.groupbar."col.active" = lib.mkForce (rgb colors.base05);

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      exec = [
        "hyprctl setcursor HYPRCURSOR_SIZE 22"
      ];
      exec-once = [
        "hypridle"
      ];

      general = {
        layout = "master";
        gaps_in = 5;
        gaps_out = 5;
      };

      workspace = [
        "s[true], gapsout:15"
      ];

      windowrulev2 = [
        "tile, class:^(Nsxiv)$" # fix nsxiv opened as float
      ];

      misc = {
        enable_swallow = true;
        swallow_regex = [
          "^(foot)$"
        ];
      };

      cursor = {
        inactive_timeout = 15;
      };

      input = {
        touchpad = {
          scroll_factor = 0.5;
          natural_scroll = true;
        };

        kb_options = "ctrl:nocaps";
      };

      decoration = {
        rounding = 5;
        dim_inactive = true;
        dim_strength = 0.15;
        shadow = {
          enabled = false;
        };
      };

      animations = {
        bezier = [
          "easeOutCubic,   0.33, 1, 0.68, 1"
        ];
        animation = [
          "windows,      1, 1, easeOutCubic, slide"
          "layers,       1, 1, easeOutCubic, fade"
          "fade,         1, 2, easeOutCubic"
          "border,       1, 2, easeOutCubic"
          "workspaces,   1, 2, easeOutCubic, slide"
          "monitorAdded, 0"
        ];
      };

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER ALT, mouse:272, resizewindow"
      ];

      bind = [
        "SUPER, q, killactive"

        "SUPER, j, layoutmsg, cyclenext"
        "SUPER, k, layoutmsg, cycleprev"
        "SUPER, h, layoutmsg, mfact -0.05"
        "SUPER, l, layoutmsg, mfact +0.05"

        "SUPER, space, layoutmsg, swapwithmaster"
        "SUPER, a, togglefloating"
        "SUPER SHIFT, a, fullscreen, 1"
        "SUPER CTRL, a, fullscreen, 0"

        "SUPER SHIFT, b, exec, ${toggleWaybar}"

        "SUPER, comma, focusmonitor, -1"
        "SUPER, period, focusmonitor, +1"

        "SUPER, escape, exec, power-menu"
        "SUPER, return, exec, ${config.uimaConfig.programs.terminal.executable}"
        "SUPER, o, exec, app-launcher"
        "SUPER, b, exec, ${config.uimaConfig.programs.browser.executable}"
        "SUPER SHIFT, u, exec, notify-send 'Title copied' \"$(clip | xargs fetch-title -m | clip)\""

        "SUPER, n,        exec, ${lib.getExe' noteScratchpad "open-ws-note"}"
        "SUPER SHIFT, n,  exec, ${lib.getExe' noteScratchpad "open-note"}"
        "SUPER, t,        exec, ${lib.getExe' termScratchpad "open-ws-term"}"
        "SUPER SHIFT, t,  exec, ${lib.getExe' termScratchpad "open-term"}"
        "SUPER, p,        exec, ${lib.getExe' tempScratchpad "open-ws-temp"}"
        "SUPER SHIFT, p,  exec, ${lib.getExe' tempScratchpad "open-temp"}"
        "SUPER, m,        exec, ${lib.getExe' musicScratchpad "open-ws-music"}"
        "SUPER SHIFT, m,  exec, ${lib.getExe' musicScratchpad "open-music"}"

        ",        Print, exec, screenshot full"
        "Shift,   Print, exec, screenshot cur"
        "Control, Print, exec, screenshot sel"
        ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86MonBrightnessDown, exec, brightnessctl set 3%-"
        ", XF86MonBrightnessUp,   exec, brightnessctl set +3%"
      ]
      ++ (
        let
          bindWin = key: ws: [
            # focus workspace will also close any activated special workspace
            # ref: https://github.com/hyprwm/Hyprland/issues/7662#issuecomment-2502280786
            "SUPER, ${key}, togglespecialworkspace, __TEMP"
            "SUPER, ${key}, togglespecialworkspace, __TEMP"
            "SUPER, ${key}, focusworkspaceoncurrentmonitor, ${ws}"

            # move window to a workspace and bring that workspace into the focused monitor.
            # note: with just `movetoworkspace`, if the window is moved to a
            # workspace on a different monitor, the focus also switches to that
            # monitor, I don't want that, I want my focus to stay on the
            # current monitor and current window.
            "SUPER SHIFT, ${key}, movetoworkspacesilent, ${ws}"
            "SUPER SHIFT, ${key}, focusworkspaceoncurrentmonitor, ${ws}"
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
        ++ (bindWin "x" "1")
        ++ (bindWin "c" "2")
        ++ (bindWin "v" "3")
        ++ (bindWin "s" "4")
        ++ (bindWin "d" "5")
        ++ (bindWin "f" "6")
        ++ (bindWin "w" "7")
        ++ (bindWin "e" "8")
        ++ (bindWin "r" "9")
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
  # - toggle idle service
  # - fprint from screen off (will unlock but screen didn't light)
  services.hypridle = {
    enable = false;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        # unlock_cmd = "notify-send unlock_cmd && hyprctl dispatch dpms on";
        # on_unlock_cmd = "notify-send on_unlock_cmd && hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 480; # 8min.
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 600; # 10min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          on-resume = "loginctl unlock-session";
        }
        {
          timeout = 660; # 11min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 3600; # 60min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;

    settings = {
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

      input-field = {
        position = "0, -200";
      };

      label = [
        {
          monitor = [ "eDP-1" ];
          text = ''cmd[update:1000] date +"%a %b %d"'';
          font_size = 80;
          color = rgb colors.base05;
          font_family = config.stylix.fonts.monospace.name;
          position = "0, 200";
        }
        {
          monitor = [ "eDP-1" ];
          text = ''cmd[update:1000] date +"%H:%M"'';
          font_size = 175;
          color = rgb colors.base05;
          font_family = config.stylix.fonts.monospace.name;
        }
      ];
    };
  };
}
