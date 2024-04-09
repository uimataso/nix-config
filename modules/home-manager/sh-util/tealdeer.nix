{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.sh-util.tealdeer;
in
{
  options.myConfig.sh-util.tealdeer = {
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
