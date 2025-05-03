{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.game.osu;
in
{
  options.uimaConfig.programs.game.osu = {
    enable = mkEnableOption "osu";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".local/share/osu"
      ];
    };

    # FIXME: wayland flag
    home.packages = with pkgs; [
      osu-lazer-bin
    ];
  };
}
