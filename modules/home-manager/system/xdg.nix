{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.system.xdg;
in
{
  options.uimaConfig.system.xdg = {
    enable = mkEnableOption ''
      XDG Base Directory
      <https://wiki.archlinux.org/title/XDG_Base_Directory>
    '';
  };

  config = mkIf cfg.enable {
    xdg.enable = true;
    xdg.mimeApps.enable = true;

    xresources.path = "${config.xdg.configHome}/x11/xresources";

    # gtkrc-2.0
    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    nix.settings.use-xdg-base-directories = true;

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

      # parallel
      PARALLEL_HOME = "${config.xdg.configHome}/parallel";

      # python
      PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
      PYTHONUSERBASE = "${config.xdg.dataHome}/python";
    };
  };
}
