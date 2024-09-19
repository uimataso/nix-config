{ config
, lib
, pkgs
, ...
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
      lazydocker
    ];

    home.shellAliases = {
      lzd = "lazydocker";
      dk = "docker";
      dkp = "docker ps";
      dkc = "docker compose";
      dkcu = "docker compose up -d";
      dkcd = "docker compose down";
      dkcl = "docker compose logs";
      dkcp = "docker compose pull";
    };
  };
}
