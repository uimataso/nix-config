{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.unfree.figma;
in
{
  options.uimaConfig.programs.unfree.figma = {
    enable = mkEnableOption "figma";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/figma-linux"
      ];
    };

    home.packages = with pkgs; [
      figma-linux
    ];
  };
}
