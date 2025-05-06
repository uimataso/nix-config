{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.hoppscotch;
in
{
  options.uimaConfig.programs.misc.hoppscotch = {
    enable = mkEnableOption "Hoppscotch";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".cache/hoppscotch-desktop"
        ".config/io.hoppscotch.desktop"
        ".local/share/hoppscotch-desktop"
        ".local/share/io.hoppscotch.desktop"
      ];
    };

    home.packages = with pkgs; [
      hoppscotch
    ];
  };
}
