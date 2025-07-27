{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.anki;
in
{
  options.uimaConfig.programs.misc.anki = {
    enable = mkEnableOption "anki";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".local/share/Anki2"
      ];
    };

    programs.anki = {
      enable = true;
      language = "en_US";

      sync = {
        autoSync = true;
        # TODO: sops secret?
        # secrets = config.sops.secrets;
        # usernameFile = mkIf (secrets ? "anki-username") secrets.anki-username.path;
        # usernameFile = mkIf (secrets ? "anki-password") secrets.anki-password.path;
      };

      theme = config.stylix.polarity;

      addons = [
        pkgs.ankiAddons.anki-connect
      ];

      answerKeys = [
        {
          ease = 1;
          key = "h";
        }
        {
          ease = 2;
          key = "j";
        }
        {
          ease = 3;
          key = "k";
        }
        {
          ease = 4;
          key = "l";
        }
      ];
    };
  };
}
