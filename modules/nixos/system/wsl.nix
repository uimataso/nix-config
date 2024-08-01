{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.system.wsl;
in
{
  options.uimaConfig.system.wsl = {
    enable = mkEnableOption "WSL";

    docker = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Docker integration";
    };
  };

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = "uima";
      docker-desktop.enable = true;
    };

    # Manual start dockerd
    # TODO: Figure out a better other way to do this, but, this works :)
    system.activationScripts = {
      startDocker.text = ''
        nohup ${pkgs.docker}/bin/dockerd > /tmp/docker.log 2> /tmp/docker.err.log &
      '';
    };
  };
}
