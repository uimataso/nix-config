{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.sh-util.bat;
in
{
  options.myConfig.sh-util.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config.theme = "base16";
    };
  };
}
