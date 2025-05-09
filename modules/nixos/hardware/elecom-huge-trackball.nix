# Deprecated: I don't use the trackball anymore. Be aware that this config may be very outdated.

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.hardware.elecomHugeTrackball;
in
{
  options.uimaConfig.hardware.elecomHugeTrackball = {
    enable = mkEnableOption "ELECOM TrackBall Mouse HUGE TrackBall";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libinput ];

    # note: Commands `udevadm`, `systemd-hwdb` and `libinput` is main commands you can look at.
    # - Use `udevadm test /sys/class/input/eventX` to see options value
    # - Use `evtest` to monitor key press and possible key values

    # todo: How the fuck can I get all the property possible???

    # Key positions:
    # 1 -> L
    # 2 -> R
    # 3 -> Mid
    # 4 -> < (above wheel)
    # 5 -> > (above wheel)
    # 6 -> Fn1
    # 7 -> Fn2
    # 8 -> Fn3

    # I don't know how to set `EmulateWheel`, so I use difference mapping as below
    # todo: bind key to `key_blue` or whatever, then set that key code as scroll button, maybe in river,
    # see: https://github.com/WaffleLapkin/nixos/blob/e869afe5d0563015d1fde92ca8d1c32751bce3f4/configuration.nix#L308
    services.udev.extraHwdb = ''
      *HUGE*TrackBall*
       KEYBOARD_KEY_90002=btn_middle
       KEYBOARD_KEY_90008=btn_right
       KEYBOARD_KEY_90005=key_pagedown
       KEYBOARD_KEY_90004=key_pageup
       KEYBOARD_KEY_90006=btn_side
       KEYBOARD_KEY_90007=btn_extra
    '';

    # services.xserver.extraConfig = ''
    #   Section "InputClass"
    #     Identifier "ELECOM trackball catchall"
    #     MatchProduct "ELECOM TrackBall Mouse HUGE TrackBall"
    #     MatchVendor "ELECOM"
    #     MatchIsPointer "yes"
    #     Driver "libinput"
    #     Option "Buttons" "12"
    #     Option "ButtonMapping" "1 2 2 4 5 6 7 8 12 10 11 3"
    #     Option "EmulateWheel" "true"
    #     Option "EmulateWheelButton" "9"
    #     Option "EmulateWheelTimeout" "0"
    #     Option "ScrollMethod" "button"
    #     Option "ScrollButton" "9"
    #     Option "ScrollPixelDistance" "32"
    #   EndSection
    # '';
  };
}
