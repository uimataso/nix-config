{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.uimaConfig.programs.sh-util.herdr;

  flakeDir = config.uimaConfig.global.flakeDir;
in
{
  options.uimaConfig.programs.sh-util.herdr = {
    enable = mkEnableOption "herdr";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/herdr"
        ".local/state/herdr"
      ];
    };

    xdg.configFile."herdr/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home-manager/programs/sh-util/herdr.toml";

    home.packages = with pkgs; [
      herdr
    ];
  };
}
