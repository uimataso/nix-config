{ pkgs, ... }:

{
  imports = [
    ./xsession.nix
    ./xresources.nix
    ./wallpaper.nix
    ./dunst.nix
  ];

  home.packages = with pkgs; [
    xcompmgr
    xclip
    xorg.xrandr
  ];

  xsession.initExtraList = [
    "xcompmgr/bin/xcompmgr -n &"
    "dwmblocks &"
    "xrandr --output HDMI-0 --mode 1920x1080 --rate 144.00"
  ];

  # unclutter
  services.unclutter.enable = true;
}
