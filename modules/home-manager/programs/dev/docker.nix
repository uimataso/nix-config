{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.docker;
in
{
  options.uimaConfig.programs.dev.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      docker-compose
    ];

    home.shellAliases = {
      d = "docker";
      dp = "docker ps";
      dc = "docker compose";
      dcu = "docker compose up -d";
      dcd = "docker compose down";
      dcl = "docker compose logs";
      dcp = "docker compose pull";
    };

    home.sessionVariables = {
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    };
  };
}
