{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.xserver.sddm;
in
{
  options.uimaConfig.desktop.xserver.sddm = {
    enable = mkEnableOption "sddm";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      theme = "astronaut";

      settings = {
        X11.UserAuthFile = ".cache/Xauthority";
      };
    };

    environment.systemPackages = with pkgs; [ sddm-astronaut-theme ];

    services.xserver.displayManager.sessionCommands =
      # sh
      ''
        [[ -f $XDG_DATA_HOME/x11/xprofile ]] && . $XDG_DATA_HOME/x11/xprofile
        [[ -f $XDG_DATA_HOME/x11/xsession ]] && . $XDG_DATA_HOME/x11/xsession
      '';
  };
}
