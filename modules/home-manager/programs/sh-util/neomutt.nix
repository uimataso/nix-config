{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.neomutt;
in
{
  options.uimaConfig.programs.sh-util.neomutt = {
    enable = mkEnableOption "neomutt";
  };

  config = mkIf cfg.enable {
    # uimaConfig.system.impermanence = {
    #   directories = [ ".config/aerc" ];
    # };

    programs.neomutt = {
      enable = true;
    };
  };
}
