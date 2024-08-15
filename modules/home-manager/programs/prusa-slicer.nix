{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.prusa-slicer;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.prusa-slicer = {
    enable = mkEnableOption "Prusa Slicer";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ prusa-slicer ];

    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/PrusaSlicer"
        ".local/share/PrusaSlicer"
      ];
    };
  };
}
