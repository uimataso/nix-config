{
  config,
  lib,
  ...
}:
# Need hosts/udisks2 to work
with lib; let
  cfg = config.uimaConfig.programs.udiskie;
in {
  options.uimaConfig.programs.udiskie = {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {services.udiskie.enable = true;};
}
