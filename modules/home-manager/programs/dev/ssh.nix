# TODO: secrets
{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.ssh;
in
{
  options.uimaConfig.programs.dev.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".ssh" ];
    };

    programs.ssh.enable = true;
  };
}
