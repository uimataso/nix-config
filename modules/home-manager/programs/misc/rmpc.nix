{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.rmpc;
in
{
  options.uimaConfig.programs.misc.rmpc = {
    enable = mkEnableOption "rmpc";
  };

  config = mkIf cfg.enable {
    programs.rmpc = {
      enable = true;
    };
  };
}
