{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.virt.podman;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.virt.waydroid = {
    enable = mkEnableOption "Waydroid";
  };

  # TODO: https://apkcombo.com/line/jp.naver.line.android/download/apk

  config = mkIf cfg.enable {
    environment.persistence.main = mkIf imper.enable { directories = [ "/var/lib/waydroid" ]; };

    virtualisation.waydroid.enable = true;
  };
}
