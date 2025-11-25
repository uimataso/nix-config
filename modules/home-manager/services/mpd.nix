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
