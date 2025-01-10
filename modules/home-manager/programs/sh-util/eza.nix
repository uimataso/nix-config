{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.eza;
in
{
  options.uimaConfig.programs.sh-util.eza = {
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
