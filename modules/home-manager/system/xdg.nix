{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.xdg;

  imper = config.uimaConfig.system.impermanence;
  rmHomePath = str: removePrefix config.home.homeDirectory str;
in
{
  options.uimaConfig.system.xdg = {
    enable = mkEnableOption "xdg";
  };

  config = mkIf cfg.enable rec {
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

    # .nix-profile
    nix.settings.use-xdg-base-directories = true;

    # wget
    home.sessionVariables = { WGETRC = "${config.xdg.configHome}/wgetrc"; };
    home.file.".config/wgetrc".text = "hsts-file = ${config.xdg.cacheHome}/wget-hsts";

    # .compose-cache
    home.sessionVariables = {
      XCOMPOSEFILE = "${config.xdg.cacheHome}/X11/xcompose";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    };

    home.persistence.main = mkIf imper.enable {
      directories =
        let
          dirs = with config.xdg.userDirs; [
            desktop
            documents
            download
            music
            pictures
            publicShare
            templates
            videos
          ];
        in
        lists.forEach (lists.remove null dirs) rmHomePath;
    };
  };
}
