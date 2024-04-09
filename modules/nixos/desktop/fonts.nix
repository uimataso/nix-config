{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.desktop.fonts;
in
{
  options.myConfig.desktop.fonts = {
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
