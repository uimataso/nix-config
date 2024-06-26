{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.xdg-user-dirs;

  imper = config.uimaConfig.system.impermanence;
  rmHomePath = str: removePrefix config.home.homeDirectory str;
in
{
  options.uimaConfig.system.xdg-user-dirs = {
    enable = mkEnableOption "XDG User Dirs";
  };

  config = mkIf cfg.enable rec {
    xdg.userDirs = mkIf cfg.enable {
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
