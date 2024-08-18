{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.xserver.qtile;
in
{
  options.uimaConfig.desktop.xserver.qtile = {
    enable = mkEnableOption "Qtile";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    services.xserver.windowManager.qtile = {
        enable = true;
    };
  };
}
