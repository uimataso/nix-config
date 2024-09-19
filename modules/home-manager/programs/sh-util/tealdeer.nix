{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.tealdeer;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.sh-util.tealdeer = {
    enable = mkEnableOption "tealdeer";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { directories = [ ".cache/tealdeer" ]; };

    programs.tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };
  };
}
