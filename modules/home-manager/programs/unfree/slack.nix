{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.unfree.slack;
in
{
  options.uimaConfig.programs.unfree.slack = {
    enable = mkEnableOption "Slack";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/Slack"
      ];
    };

    home.packages = with pkgs; [
      slack
    ];
  };
}
