{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.unfree.google-chrome;
in
{
  options.uimaConfig.programs.unfree.google-chrome = {
    enable = mkEnableOption "Google Chrome";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/google-chrome"
      ];
    };

    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
