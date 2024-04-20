{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.xsession;
in
{
  options.uimaConfig.desktop.xserver.xsession = {
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
