{ pkgs, ... }:
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

    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 5;
      };

      decoration = {
        rounding = 3;
      };

      # bindm = [
      #   "$mod, mouse:272, movewindow"
      #   "$mod, mouse:273, resizewindow"
      #   "$mod ALT, mouse:272, resizewindow"
      # ];

      bind = [
        "SUPER, q, killactive"

        "SUPER, Return, exec, $TERMINAL"
        "SUPER, o, exec, app-launcher"
      ];
    };
  };
}
