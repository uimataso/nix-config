{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.system.pipewire;
in
{
  options.uimaConfig.system.pipewire = {
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
