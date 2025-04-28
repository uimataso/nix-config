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
            "layers,     1, 5, easeOutCubic, fade"
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

            "SUPER, return, exec, $TERMINAL"
            "SUPER, escape, exec, power-menu"
            "SUPER, o, exec, app-launcher"
            "SUPER, b, exec, $BROWSER"

            "SUPER, n, exec, ${noteScratchpad}/bin/open-ws-note"
            "SUPER SHIFT, n, exec, ${noteScratchpad}/bin/open-note"
            "SUPER, t, exec, ${termScratchpad}/bin/open-ws-term"
            "SUPER SHIFT, t, exec, ${termScratchpad}/bin/open-term"
            "SUPER, s, exec, ${tempScratchpad}/bin/open-ws-temp"
            "SUPER SHIFT, s, exec, ${tempScratchpad}/bin/open-temp"
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
}
