{ config, ... }:

{
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = null;
    documents = "${config.home.homeDirectory}/doc";
    download = "${config.home.homeDirectory}/dl";
    music = "${config.home.homeDirectory}/mus";
    pictures = "${config.home.homeDirectory}/img";
    publicShare = null;
    templates = null;
    videos = "${config.home.homeDirectory}/vid";
  };

  xdg.mimeApps.enable = true;

  # wget
  home.sessionVariables = { WGETRC = "${config.xdg.configHome}/wgetrc"; };
  home.file.".config/wgetrc".text = "hsts-file = ${config.xdg.cacheHome}/wget-hsts";

  # .compose-cache
  home.sessionVariables = {
    XCOMPOSEFILE = "${config.xdg.cacheHome}/X11/xcompose";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
  };
}
