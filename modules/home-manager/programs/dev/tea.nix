{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.tea;
in
{
  options.uimaConfig.programs.dev.tea = {
    enable = mkEnableOption "tea, cli for gitea";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".config/tea" ];
    };

    home.packages = with pkgs; [
      tea
    ];
  };
}
