{ config, lib, ... }:

with lib;

# TODO: manage git key

let
  cfg = config.myConfig.dev.git;
in {
  options.myConfig.dev.git = {
    enable = mkEnableOption "Git";

    name = mkOption {
      type = types.string;
      default = "uima";
      description = "Username to use in git.";
    };
    email = mkOption {
      type = types.string;
      default = "luck07051@gmail.com";
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
