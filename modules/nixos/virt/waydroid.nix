{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.virt.podman;
in
{
  options.uimaConfig.virt.waydroid = {
    enable = mkEnableOption "Waydroid";
  };

  # TODO: https://apkcombo.com/line/jp.naver.line.android/download/apk

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ "/var/lib/waydroid" ];
    };

    virtualisation.waydroid.enable = true;
  };
}
