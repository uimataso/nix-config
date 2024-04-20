{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.tealdeer;
in
{
  options.uimaConfig.sh-util.tealdeer = {
    enable = mkEnableOption "tealdeer";
  };

  config = mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
      settings = {
        updates = { auto_update = true; };
      };
    };
  };
}
