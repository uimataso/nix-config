{ config
, lib
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.system.xdgUserDirs;

  imper = config.uimaConfig.system.impermanence;
  rmHomePath = str: lib.removePrefix config.home.homeDirectory str;
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
{
  options.uimaConfig.system.xdgUserDirs = {
    enable = mkEnableOption "XDG User Dirs";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = lib.lists.forEach (lib.lists.remove null dirs) rmHomePath;
    };

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

  };
}
