{
  config,
  pkgs,
  lib,
  ...
}:
{

  home.packages = with pkgs; [
    scripts.power-menu
    scripts.app-launcher
    scripts.screenshot
    scripts.vl
    scripts.bright
  ];

  home.shellAliases = {
    hl = "Hyprland";
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

        general = {
          layout = "master";
          gaps_in = 5;
          gaps_out = 5;
        };

        decoration = {
          rounding = 5;
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

            "SUPER, Return, exec, $TERMINAL"
            "SUPER, o, exec, app-launcher"
            "SUPER, escape, exec, power-menu"
            "SUPER, b, exec, $BROWSER"
          ]
          ++ (
            let
              bindWin = key: ws: [
                "SUPER, ${key}, workspace, ${ws}"
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
      };
  };
}
