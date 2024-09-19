{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.prusaSlicer;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.prusaSlicer = {
    enable = mkEnableOption "Prusa Slicer";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/PrusaSlicer"
        ".local/share/PrusaSlicer"
      ];
    };

    home.packages = with pkgs; [ prusa-slicer ];
  };
}
