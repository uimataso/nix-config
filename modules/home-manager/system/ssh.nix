{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.system.ssh;
in
{
  options.uimaConfig.system.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh.enable = true;

    home.persistence.main = mkIf imper.enable {
      directories = [ ".ssh" ];
    };
  };
}
