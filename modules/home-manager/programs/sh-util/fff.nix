{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.fff;

  shUtil = config.uimaConfig.programs.sh-util;
in
{
  options.uimaConfig.programs.sh-util.fff = {
    enable = mkEnableOption "fff. Self written script for file browsing.";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.fff ];

    home.shellAliases = {
      a = ". fff";
    };

    programs.nushell.shellAliases = {
      # TODO: cd side effert, or rewrite for nu?
      a = "fff";
    };

    home.sessionVariables =
      let
        ls =
          if shUtil.eza.enable then
            "eza --color=always"
          else if shUtil.lsd.enable then
            "lsd --color=always"
          else
            "ls --color=always";

        ls_cmd =
          if shUtil.eza.enable then
            "${ls} -A1 --group-directories-first"
          else
            "${ls} -A --group-directories-first";
      in
      {
        FFF_LS_CMD = ls_cmd;
        PREVIEW_LS_CMD = ls_cmd;
        PREVIEW_LS_L_CMD = "${ls} -l";
      };
  };
}
