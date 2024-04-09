{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver.wm.dwm;
in
{
  options.myConfig.desktop.xserver.wm.dwm = {
    enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    myConfig.desktop.xserver.xsession.initExtraList = [
      "dwmblocks &"
    ];

    home.sessionPath = [ "$HOME/.local/bin/statesbar" ];
    home.file.".local/bin/statesbar".source = ./statusbar;
  };
}
