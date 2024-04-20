{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver.wm.dwm;
in
{
  options.uimaConfig.desktop.xserver.wm.dwm = {
    enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    xsession.initExtra = "dwmblocks &";

    home.sessionPath = [ "$HOME/.local/bin/statesbar" ];
    home.file.".local/bin/statesbar".source = ./statusbar;
  };
}
