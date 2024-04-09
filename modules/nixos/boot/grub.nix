{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.boot.grub;
in {
  options.myConfig.boot.grub = {
    enable = mkEnableOption "Grub";
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
