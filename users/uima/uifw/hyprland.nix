{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkForce;
in
{

  home.packages = with pkgs; [
    scripts.power-menu
    scripts.app-launcher
    scripts.screenshot
    scripts.vl
    scripts.bright
  ];

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

        bind = [
          "SUPER, q, killactive"

          "SUPER, j, layoutmsg, cyclenext"
          "SUPER, k, layoutmsg, cycleprev"
          "SUPER, h, layoutmsg, mfact -0.05"
          "SUPER, l, layoutmsg, mfact +0.05"

          "SUPER, Return, exec, $TERMINAL"
          "SUPER, o, exec, app-launcher"
          "SUPER, escape, exec, power-menu"
        ];
      };
  };
}
