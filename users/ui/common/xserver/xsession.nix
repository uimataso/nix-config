{ config, lib, ... }:

{
  options = {
    xsession.initExtraList = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression "[ \"xset s off -dpms\" ]";
      description = lib.mdDoc "List of shell commands executed at init.";
    };
  };

  config = {
    xsession = {
      enable = true;
      profilePath = "${config.xdg.dataHome}/x11/xprofile";
      scriptPath = "${config.xdg.dataHome}/x11/xsession";
      initExtra = lib.strings.concatLines config.xsession.initExtraList;

      initExtraList = [ "xset s off -dpms" ];
    };
  };
}
