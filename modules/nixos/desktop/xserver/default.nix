{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver;
in
{
  options.uimaConfig.desktop.xserver = {
    enable = mkEnableOption "Xserver";
  };

  imports = [
    ./dwm.nix
    ./sddm.nix
  ];

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    # TODO: move this to other place
    services.xserver.extraConfig = ''
      Section "InputClass"
        Identifier "ELECOM trackball catchall"
        MatchProduct "ELECOM TrackBall Mouse HUGE TrackBall"
        MatchVendor "ELECOM"
        MatchIsPointer "yes"
        Driver "libinput"
        Option "Buttons" "12"
        Option "ButtonMapping" "1 2 2 4 5 6 7 8 12 10 11 3"
        Option "EmulateWheel" "true"
        Option "EmulateWheelButton" "9"
        Option "EmulateWheelTimeout" "0"
        Option "ScrollMethod" "button"
        Option "ScrollButton" "9"
        Option "ScrollPixelDistance" "32"
      EndSection
    '';
  };
}
