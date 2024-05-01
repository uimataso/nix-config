{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.virt.podman;
in
{
  options.uimaConfig.virt.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      podman-compose
    ];

    home.shellAliases = {
      pm = "podman";
      pms = "podman ps";
      pmc = "podman compose";
      pmcu = "podman compose up -d";
      pmcd = "podman compose down";
      pmcl = "podman compose logs";
      pmcp = "podman compose pull";
    };
  };
}
