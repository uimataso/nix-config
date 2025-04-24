{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.thunderbird;
in
{
  options.uimaConfig.programs.misc.thunderbird = {
    enable = mkEnableOption "Thunderbird";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".thunderbird"
      ];
    };

    # programs.thunderbird = {
    #   enable = true;
    # };

    home.packages = with pkgs; [
      thunderbird
    ];
  };
}
