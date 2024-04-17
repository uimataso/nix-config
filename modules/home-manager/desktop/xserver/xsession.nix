{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver.xsession;
in
{
  options.myConfig.desktop.xserver.xsession = {
    enable = mkEnableOption "Xsession";
  };

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      profilePath = "${config.xdg.dataHome}/x11/xprofile";
      scriptPath = "${config.xdg.dataHome}/x11/xsession";
    };
  };
}
