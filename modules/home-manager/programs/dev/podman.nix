{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.podman;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.dev.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { directories = [ ".local/share/containers/storage" ]; };

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
  };
}
