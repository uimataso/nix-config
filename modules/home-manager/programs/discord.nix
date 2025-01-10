{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.discord;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.discord = {
    enable = mkEnableOption "Discord";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/discord"
        ".config/Vencord"
      ];
    };

    home.packages = with pkgs; [
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
