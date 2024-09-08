{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.desktop.xserver.dwmblocks;
in
{
  options.uimaConfig.desktop.xserver.dwmblocks = {
    enable = mkEnableOption "dwmblocks";
  };

  config = mkIf cfg.enable {
    xsession.initExtra = "dwmblocks &";

    home.sessionPath = [ "$HOME/.local/bin/statesbar" ];
    home.file.".local/bin/statesbar".source = ./statusbar;
  };
}
