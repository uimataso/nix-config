{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.htop;
in
{
  options.uimaConfig.programs.sh-util.htop = {
    enable = mkEnableOption "htop";
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
    };
  };
}
