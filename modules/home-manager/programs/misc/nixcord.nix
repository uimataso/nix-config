{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.nixcord;
in
{
  options.uimaConfig.programs.misc.nixcord = {
    enable = mkEnableOption "Nixcord";
  };

  imports = [ inputs.nixcord.homeModules.nixcord ];

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/discord"
        ".config/vesktop"
      ];
    };

    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      config = {
        frameless = true;

        plugins = {
          # fakeNitro.enable = true;
        };
      };
    };
  };
}
