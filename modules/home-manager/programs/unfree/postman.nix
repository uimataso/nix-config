{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.unfree.postman;
in
{
  options.uimaConfig.programs.unfree.postman = {
    enable = mkEnableOption "Postman";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/Postman"
      ];
    };

    home.packages = with pkgs; [
      postman
    ];
  };
}
