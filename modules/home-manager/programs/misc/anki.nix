{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.anki;
in
{
  options.uimaConfig.programs.misc.anki = {
    enable = mkEnableOption "anki";
  };

  config = mkIf cfg.enable {
    # uimaConfig.system.impermanence = {
    #   directories = [
    #     ".local/share/calibre"
    #     ".config/calibre"
    #   ];
    # };

    programs.anki = {
      enable = true;
    };
  };
}
