{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver.xsession;
in {
  options.myConfig.desktop.xserver.xsession = {
    enable = mkEnableOption "Xsession";

    initExtraList = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = lib.literalExpression "[ \"xset s off -dpms\" ]";
      description = lib.mdDoc "List of shell commands executed at init.";
    };
  };

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      profilePath = "${config.xdg.dataHome}/x11/xprofile";
      scriptPath = "${config.xdg.dataHome}/x11/xsession";
      initExtra = strings.concatLines cfg.initExtraList;
    };
  };
}
