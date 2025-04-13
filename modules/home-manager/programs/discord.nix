{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.discord;
in
{
  options.uimaConfig.programs.discord = {
    enable = mkEnableOption "Discord";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
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
