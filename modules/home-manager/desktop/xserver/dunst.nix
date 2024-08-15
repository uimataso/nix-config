{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.uimaConfig.desktop.xserver.dunst;
in {
  options.uimaConfig.desktop.xserver.dunst = {
    enable = mkEnableOption "dunst";
  };

  config = {
    home.packages = with pkgs; [libnotify];

    services.dunst = {
      enable = true;

      settings = {
        global = {
          monitor = 0;
          follow = "keyboard";
          width = "(0, 300)";
          height = 300;
          origin = "top-right";
          offset = "20x35";
          transparency = 0;
          padding = 12;
          horizontal_padding = 12;
          text_icon_padding = 0;
          frame_width = 0;
          gap_size = 4;

          line_height = 1;

          enable_recursive_icon_lookup = true;
        };
      };
    };
  };
}
