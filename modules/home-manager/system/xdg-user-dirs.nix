{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.system.xdgUserDirs;

  xdgDirs = {
    desktop = null;
    documents = "doc";
    download = "dl";
    music = "mus";
    pictures = "img";
    publicShare = null;
    templates = null;
    videos = "vid";
  };
in
{
  options.uimaConfig.system.xdgUserDirs = {
    enable = mkEnableOption "XDG User Dirs";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = lib.lists.remove null (builtins.attrValues xdgDirs);
    };

    xdg.userDirs =
      {
        enable = true;
        createDirectories = true;
      }
      // lib.attrsets.mapAttrs (
        key: val: if builtins.isNull val then val else "${config.home.homeDirectory}/${val}"
      ) xdgDirs;
  };
}
