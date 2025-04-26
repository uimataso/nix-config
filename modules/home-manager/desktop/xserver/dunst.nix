{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.desktop.xserver.dunst;
in
{
  options.uimaConfig.desktop.xserver.dunst = {
    enable = mkEnableOption "dunst";
  };

  # NOTE: This module also used in wayland, so when you make a change that only make sense to xserver, fix wayland side.

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ libnotify ];

    services.dunst = {
      enable = true;

      settings = {
        global = {
          follow = "keyboard";
          width = "(200, 300)";
          origin = "top-right";
          padding = 12;
          horizontal_padding = 12;
          frame_width = 1;
          gap_size = 4;
          line_height = 1;

          enable_recursive_icon_lookup = true;
        };

        urgency_low = {
          frame_color = mkForce "#00000000";
        };
        urgency_normal = {
          frame_color = mkForce "#00000000";
        };
      };
    };
  };
}
