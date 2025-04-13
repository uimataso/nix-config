{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.wikiman;
in
{
  options.uimaConfig.programs.wikiman = {
    enable = mkEnableOption "Wikiman";
  };

  # TODO:
  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
      ];
    };

    home.packages = with pkgs; [ wikiman ];

    # xdg.configFile = {
    #   "wikiman/wikiman.conf".text = ''
    #   '';
    # };
  };
}
