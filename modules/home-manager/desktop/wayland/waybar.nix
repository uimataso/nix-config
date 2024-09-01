{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.wayland.waybar;

  scheme = config.stylix.base16Scheme;
in
{
  options.uimaConfig.desktop.wayland.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      # settings = [];
    };
  };
}
