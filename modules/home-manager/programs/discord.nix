{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.programs.discord;

  ifImpermanence = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
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

    home.persistence.main = ifImpermanence {
      directories = [
        ".config/discord"
        ".config/Vencord" # TODO: declare the content
      ];
    };
  };
}
