{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.dev.jujutsu;
in
{
  options.uimaConfig.programs.dev.jujutsu = {
    enable = mkEnableOption "jujutsu";

    name = mkOption {
      type = types.str;
      description = "Username to use in git.";
    };
    email = mkOption {
      type = types.str;
      description = "User email to use in git.";
    };
  };

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = cfg.name;
          email = cfg.email;
        };
      };
    };
  };
}
