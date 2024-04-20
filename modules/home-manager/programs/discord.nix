{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.discord;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.discord = {
    enable = mkEnableOption "Discord";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];

    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/discord"
        ".config/Vencord" # TODO: declare the settings for this
      ];
    };
  };
}
