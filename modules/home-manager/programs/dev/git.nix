# TODO: secrets?
{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.dev.git;
in
{
  options.uimaConfig.programs.dev.git = {
    enable = mkEnableOption "Git";

    name = mkOption {
      type = types.str;
      default = "uima";
      description = "Username to use in git.";
    };
    email = mkOption {
      type = types.str;
      default = "git.m5svm@uimataso.com";
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
