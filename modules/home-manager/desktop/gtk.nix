{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.gtk;
in
{
  options.uimaConfig.desktop.gtk = {
    enable = mkEnableOption "GTK";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
    };

    home.packages = with pkgs; [
      libsForQt5.qtstyleplugins
    ];

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "gtk2";
    };
  };
}
