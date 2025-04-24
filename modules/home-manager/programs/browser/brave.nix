{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.browser.brave;
in
{
  options.uimaConfig.programs.browser.brave = {
    enable = mkEnableOption "Brave";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/BraveSoftware/Brave-Browser"
      ];
    };

    home.packages = with pkgs; [
      brave
    ];
  };
}
