{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.dev.direnv;
in
{
  options.uimaConfig.programs.dev.direnv = {
    enable = mkEnableOption "Enables direnv";

    whitelist = mkOption {
      type = types.attrs;
      default = {
        prefix = [ "~/src" ];
        exact = [ "~/nix" ];
      };
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      config.whitelist = cfg.whitelist;
    };
  };
}
