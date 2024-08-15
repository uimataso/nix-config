{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.virt.docker;
in
{
  options.uimaConfig.virt.docker = {
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
