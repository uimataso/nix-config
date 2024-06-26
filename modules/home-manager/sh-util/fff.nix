{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.fff;

  shUtil = config.uimaConfig.sh-util;
in
{
  options.uimaConfig.sh-util.fff = {
    enable = mkEnableOption "fff. Self written script for file browsing.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      scripts.fff
    ];

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
            "ls --color=always"
        ;

        ls_cmd =
          if shUtil.eza.enable then
            "${ls} -A1 --group-directories-first"
          else
            "${ls} -A --group-directories-first"
        ;
      in
      rec {
        FFF_LS_CMD = ls_cmd;
        PREVIEW_LS_CMD = ls_cmd;
        PREVIEW_LS_L_CMD = "${ls} -l";
      };
  };
}
