{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.libreoffice;
in
{
  options.uimaConfig.programs.misc.libreoffice = {
    enable = mkEnableOption "LibreOffice";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/libreoffice"
      ];
    };

    home.packages = with pkgs; [ libreoffice ];
  };
}
