{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.boot.grub;
in
{
  options.uimaConfig.boot.grub = {
    enable = mkEnableOption "Grub";
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      timeoutStyle = "hidden";
    };
  };
}
