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
  ];

  # xcompmgr
  xsession.initExtraList = [
    "xcompmgr -n &"
    "dwmblocks &"
  ];

  # unclutter
  services.unclutter.enable = true;
}
