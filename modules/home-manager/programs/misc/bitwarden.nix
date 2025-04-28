{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.bitwarden;
in
{
  options.uimaConfig.programs.misc.bitwarden = {
    enable = mkEnableOption "bitwarden";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/Bitwarden"
        ".config/Bitwarden CLI"
      ];
    };

    home.packages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
    ];
  };
}
