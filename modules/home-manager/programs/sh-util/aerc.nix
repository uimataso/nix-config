{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.aerc;
in
{
  options.uimaConfig.programs.sh-util.aerc = {
    enable = mkEnableOption "aerc, a pretty good email client";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".config/aerc" ];
    };

    programs.aerc = {
      enable = true;
    };
  };
}
