{ config, lib, ... }:
with lib;
# TODO: secrets
let
  cfg = config.uimaConfig.programs.dev.ssh;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.dev.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { directories = [ ".ssh" ]; };

    programs.ssh.enable = true;
  };
}