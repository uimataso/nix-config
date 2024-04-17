{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver.xcompmgr;
in
{
  options.myConfig.desktop.xserver.xcompmgr = {
    enable = mkEnableOption "Xcompmgr";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xcompmgr
    ];

    xsession.initExtra = "xcompmgr -n &";
  };
}
