{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.programs.discord;

  imper = config.myConfig.system.impermanence;
in
{
  options.myConfig.programs.discord = {
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
        ".config/Vencord" # TODO: declare the content
      ];
    };
  };
}
