{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.qbittorrent;
in
{
  options.uimaConfig.programs.misc.qbittorrent = {
    enable = mkEnableOption "qBittorrent";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/qBittorrent"
        ".local/share/qBittorrent"
      ];
    };

    home.packages = with pkgs; [ qbittorrent ];
  };
}
