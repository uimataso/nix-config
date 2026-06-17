{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.desktop.wayland.niri;
in
{
  options.uimaConfig.desktop.wayland.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      brightnessctl
      playerctl

      scripts.power-menu
      scripts.app-launcher
    ];

    # TODO:
  };
}
