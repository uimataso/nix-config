{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.hardware.pipewire;
in
{
  options.uimaConfig.hardware.pipewire = {
    enable = mkEnableOption "pipewire";
  };

  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
    };
  };
}