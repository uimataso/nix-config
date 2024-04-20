{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.fonts;
in
{
  options.uimaConfig.desktop.fonts = {
    enable = mkEnableOption "Fonts";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      material-symbols
      # awesome-terminal-fonts
    ];
  };
}
