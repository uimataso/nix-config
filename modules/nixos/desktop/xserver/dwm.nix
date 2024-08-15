{
  config,
  lib,
  pkgs,
  stdenv,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.xserver.dwm;
in
{
  options.uimaConfig.desktop.xserver.dwm = {
    enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dwmblocks ];

    services.xserver = {
      windowManager.dwm = {
        enable = true;
      };

      # displayManager.setupCommands = ''
      #   dwmblocks &
      # '';
    };
  };
}
