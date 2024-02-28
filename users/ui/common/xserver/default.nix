{ pkgs, ... }:

{
  imports = [
    ./xsession.nix
    ./xresources.nix
    ./wallpaper.nix
    ./dunst.nix
  ];

  # xcompmgr
  home.packages = [ pkgs.xcompmgr ];
  xsession.initExtraList = [
    "xcompmgr -n &"
    "dwmblocks &"
  ];

  # unclutter
  services.unclutter.enable = true;
}
