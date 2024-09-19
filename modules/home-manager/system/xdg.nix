{ config
, lib
, ...
}:
with lib;
let
  cfg = config.uimaConfig.system.xdg;
in
{
  options.uimaConfig.system.xdg = {
    enable = mkEnableOption "XDG";
  };

  config = mkIf cfg.enable {
    xdg.enable = true;
    xdg.mimeApps.enable = true;

    xresources.path = "${config.xdg.configHome}/x11/xresources";

    # .nix-profile
    nix.settings.use-xdg-base-directories = true;

    # gtkrc-2.0
    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    xdg.configFile = {
      # wget
      "wgetrc".text = "hsts-file = ${config.xdg.cacheHome}/wget-hsts";
    };

    home.sessionVariables = {
      # .compose-cache
      XCOMPOSEFILE = "${config.xdg.cacheHome}/X11/xcompose";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";

      # Cargo
      CARGO_HOME = "${config.xdg.dataHome}/cargo";

      # wget
      WGETRC = "${config.xdg.configHome}/wgetrc";
    };
  };
}
