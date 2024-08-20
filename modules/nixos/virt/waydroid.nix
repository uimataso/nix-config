{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.virt.podman;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.virt.waydroid = {
    enable = mkEnableOption "Waydroid";
  };

  # TODO: https://apkcombo.com/line/jp.naver.line.android/download/apk

  config = mkIf cfg.enable {
    virtualisation.waydroid.enable = true;

    environment.persistence.main = mkIf imper.enable { directories = [ "/var/lib/waydroid" ]; };
  };
}
