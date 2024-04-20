{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.xcompmgr;
in
{
  options.uimaConfig.desktop.xserver.xcompmgr = {
    enable = mkEnableOption "Xcompmgr";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xcompmgr
    ];

    xsession.initExtra = "xcompmgr -n &";
  };
}
