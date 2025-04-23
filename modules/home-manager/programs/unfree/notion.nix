{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.unfree.notion;
in
{
  options.uimaConfig.programs.unfree.notion = {
    enable = mkEnableOption "Notion";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/notion-app-enhanced"
      ];
    };

    home.packages = with pkgs; [
      notion-app-enhanced
    ];
  };
}
