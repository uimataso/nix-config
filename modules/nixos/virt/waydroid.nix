{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.virt.podman;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.virt.waydroid = {
    enable = mkEnableOption "Waydroid";
  };

  config = mkIf cfg.enable {
    virtualisation.waydroid.enable = true;

    environment.persistence.main = mkIf imper.enable {
      directories = [ "/var/lib/waydroid" ];
    };
  };
}
