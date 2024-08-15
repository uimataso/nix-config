{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.sh-util.eza;
in
{
  options.uimaConfig.sh-util.eza = {
    enable = mkEnableOption "eza";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      l = "eza --group-directories-first";
      ls = "eza -A --group-directories-first";
      ll = "eza -Al --group-directories-first";
    };

    programs.eza = {
      enable = true;
    };
  };
}
