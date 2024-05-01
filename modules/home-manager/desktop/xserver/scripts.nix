{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.scripts;
in
{
  options.uimaConfig.desktop.xserver.scripts = {
    enable = mkEnableOption "Some scripts for xserver";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      scripts.open
      scripts.power-menu
      scripts.app-launcher
      scripts.swallower
      scripts.screenshot
    ];
  };
}
