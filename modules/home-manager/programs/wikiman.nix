{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.wikiman;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.wikiman = {
    enable = mkEnableOption "Wikiman";
  };

  # TODO:
  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
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
