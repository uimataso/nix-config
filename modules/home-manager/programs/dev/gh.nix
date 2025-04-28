{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.gh;
in
{
  options.uimaConfig.programs.dev.gh = {
    enable = mkEnableOption "gh, GitHub CLI";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".config/gh" ];
    };

    home.packages = with pkgs; [
      gh
    ];
  };
}
