{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.anki;

  dataDir = ".local/share/Anki2";
in
{
  options.uimaConfig.programs.misc.anki = {
    enable = mkEnableOption "anki";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        dataDir
      ];
    };

    stylix.targets.anki.enable = false;

    programs.anki = {
      enable = true;
      language = "en_US";

      sync = {
        autoSync = true;
        autoSyncMediaMinutes = 15;
        usernameFile = "${config.home.homeDirectory}/${dataDir}/nix/username";
        passwordFile = "${config.home.homeDirectory}/${dataDir}/nix/password";
        # TODO: sops secret?
        # secrets = config.sops.secrets;
        # usernameFile = mkIf (secrets ? "anki-username") secrets.anki-username.path;
        # passwordFile = mkIf (secrets ? "anki-password") secrets.anki-password.path;
      };

      theme = config.stylix.polarity;

      addons = [
        pkgs.ankiAddons.anki-connect
        # (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
        #   pname = "crowd-anki";
        #   version = "20231030";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "Stvad";
        #     repo = "CrowdAnki";
        #     rev = "907381102f22323e0a4f8eb49d536ad18de81ec5";
        #     # sparseCheckout = [ "crowd_anki" ];
        #     hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
        #   };
        #   # sourceRoot = "${finalAttrs.src.name}/crowd_anki";
        # }))
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
