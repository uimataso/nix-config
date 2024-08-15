{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.uimaConfig.sh-util.tealdeer;

  imper = config.uimaConfig.system.impermanence;
in {
  options.uimaConfig.sh-util.tealdeer = {
    enable = mkEnableOption "tealdeer";
  };

  config = mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };

    home.persistence.main = mkIf imper.enable {directories = [".cache/tealdeer"];};
  };
}
