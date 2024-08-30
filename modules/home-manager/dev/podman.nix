{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.dev.podman;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.dev.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ podman-compose ];

    home.shellAliases = {
      pm = "podman";
      pmp = "podman ps";
      pmc = "podman compose";
      pmcu = "podman compose up -d";
      pmcd = "podman compose down";
      pmcl = "podman compose logs";
      pmcp = "podman compose pull";
    };

    home.persistence.main = mkIf imper.enable { directories = [ ".local/share/containers/storage" ]; };
  };
}
