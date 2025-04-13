{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.system.pipewire;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.system.pipewire = {
    enable = mkEnableOption "Settings and tool for pipewire";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".local/state/wireplumber" ];
    };
  };
}
