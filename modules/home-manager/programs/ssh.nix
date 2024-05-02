{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.ssh;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh.enable = true;

    home.persistence.main = mkIf imper.enable {
      directories = [ ".ssh" ];
    };
  };
}
