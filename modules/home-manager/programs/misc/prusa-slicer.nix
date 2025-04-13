{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.prusaSlicer;
in
{
  options.uimaConfig.programs.misc.prusaSlicer = {
    enable = mkEnableOption "Prusa Slicer";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/PrusaSlicer"
        ".local/share/PrusaSlicer"
      ];
    };

    home.packages = with pkgs; [ prusa-slicer ];
  };
}
