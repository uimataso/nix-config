{ config
, lib
, inputs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.nixcord;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.nixcord = {
    enable = mkEnableOption "Nixcord";
  };

  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".config/discord"
        ".config/vesktop"
      ];
    };

    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      config.plugins = {
        # fakeNitro.enable = true;
      };
    };
  };
}
