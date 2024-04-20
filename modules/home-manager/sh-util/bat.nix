{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.bat;
in
{
  options.uimaConfig.sh-util.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config.theme = "base16";
    };
  };
}
