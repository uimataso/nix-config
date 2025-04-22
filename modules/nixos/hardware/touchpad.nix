{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.hardware.touchpad;
in
{
  options.uimaConfig.hardware.touchpad = {
    enable = mkEnableOption "Touchpad";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libinput ];
    services.libinput = {
      enable = true;
      touchpad = {
        tappingButtonMap = "lmr";
        # naturalScrolling = false;
        additionalOptions = ''
          Option "TapToClick" "on"
        '';
      };
    };

    environment.etc."X11/xorg.conf.d/50-touchpad.conf".text = ''
      Section "InputClass"
          Identifier "Touchpad"
          Driver "libinput"
          MatchIsTouchpad "true"
          Option "Tapping" "on"
      EndSection
    '';
  };
}
