{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.podman;
in
{
  options.uimaConfig.programs.dev.podman = {
    enable = mkEnableOption "Podman";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".local/share/containers/storage" ];
    };

    home.packages = with pkgs; [ podman-compose ];

    home.shellAliases = {
      p = "podman";
      pp = "podman ps";
      pc = "podman compose";
      pcu = "podman compose up -d";
      pcd = "podman compose down";
      pcl = "podman compose logs";
      pcp = "podman compose pull";
    };
  };
}
