{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.pipewire;
in
{
  options.uimaConfig.services.pipewire = {
    enable = mkEnableOption "Settings and tool for pipewire";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".local/state/wireplumber" ];
    };

    home.packages = with pkgs; [
      pulseaudio # bin/pactl
    ];
  };
}
