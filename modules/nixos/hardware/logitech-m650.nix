{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.hardware.logitechM650;
in
{
  options.uimaConfig.hardware.logitechM650 = {
    enable = mkEnableOption "Logitech M650 mouse";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libinput ];
    services.libinput.mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
    };
  };
}
