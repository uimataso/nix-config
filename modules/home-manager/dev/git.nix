{ config, lib, ... }:

with lib;

# TODO: manage git key

let
  cfg = config.uimaConfig.dev.git;
in
{
  options.uimaConfig.dev.git = {
    enable = mkEnableOption "Git";

    name = mkOption {
      type = types.str;
      default = "uima";
      description = "Username to use in git.";
    };
    email = mkOption {
      type = types.str;
      default = "uimataso@proton.me";
      description = "User email to use in git.";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      aliases = {
        s = "status";
      };

      userName = cfg.name;
      userEmail = cfg.email;
    };
  };
}
