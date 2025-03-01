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
        ls_cmd =
          if shUtil.eza.enable then
            "eza --color=always -A1 --group-directories-first --dereference --no-quotes"
          else
            "ls --color=always -A --group-directories-first";

        preview_ls =
          if shUtil.eza.enable then
            "eza --color=always -l"
          else if shUtil.lsd.enable then
            "lsd --color=always -l"
          else
            "ls --color=always -l";
      in
      {
        FFF_LS_CMD = ls_cmd;
        PREVIEW_LS_CMD = ls_cmd;
        PREVIEW_LS_L_CMD = preview_ls;
      };
  };
}
