{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.tealdeer;
in
{
  options.uimaConfig.programs.sh-util.tealdeer = {
    enable = mkEnableOption "tealdeer";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".cache/tealdeer" ];
    };

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
