{ config
, lib
, ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.wayland.river;
in
{
  options.uimaConfig.desktop.wayland.river = {
    enable = mkEnableOption "river";
  };

  config = mkIf cfg.enable {
    programs.river = {
      enable = true;
      extraPackages = [ ];
    };
  };
}
