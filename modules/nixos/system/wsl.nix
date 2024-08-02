{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.wsl;
in
{
  options.uimaConfig.system.wsl = {
    enable = mkEnableOption "WSL";

    docker = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Docker integration";
    };
  };

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = "uima";
      docker-desktop.enable = cfg.docker;
    };

    # Manual start dockerd
    # TODO: Figure out a better other way to do this, but, this works :)
    system.activationScripts = mkIf cfg.docker {
      startDocker.text = ''
        nohup ${pkgs.docker}/bin/dockerd > /tmp/docker.log 2> /tmp/docker.err.log &
      '';
    };
  };
}
