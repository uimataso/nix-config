{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.system.sudo;
in
{
  options.uimaConfig.system.sudo = {
    enable = mkEnableOption "sudo";
  };

  config = mkIf cfg.enable {
    security.sudo = {
      enable = true;

      extraConfig = ''
        Defaults        lecture = never
      '';
    };
  };
}
