{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.system.xdgUserDirs;
in
{
  options.uimaConfig.system.xdgUserDirs = {
    enable = mkEnableOption "XDG User Dirs";

    xdgDirs = mkOption {
      type = types.attrs;
      default = {
        desktop = null;
        documents = "doc";
        download = "dl";
        music = "mus";
        pictures = "img";
        publicShare = null;
        templates = null;
        videos = "vid";
      };
      description = "XDG dirs to used";
    };
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = lib.lists.remove null (builtins.attrValues cfg.xdgDirs);
    };

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    }
    // lib.attrsets.mapAttrs (
      key: val: if builtins.isNull val then val else "${config.home.homeDirectory}/${val}"
    ) cfg.xdgDirs;
  };
}
