{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.mpd;
in
{
  options.uimaConfig.services.mpd = {
    enable = mkEnableOption "mpd";

  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        # services.mpd.dataDir = "$XDG_DATA_HOME/mpd";
        ".local/share/mpd"
      ];
    };

    home.packages = with pkgs; [
      mpc
    ];

    services.mpd = {
      enable = true;
      musicDirectory = "/share/no-backup/yt-dlp/";
      extraConfig = ''
        auto_update "yes"
        restore_paused "yes"

        audio_output {
          type "pipewire"
          name "PipeWire"
        }
      '';
    };

  };
}
