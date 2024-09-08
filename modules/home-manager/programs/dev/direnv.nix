{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.programs.dev.direnv;
in
{
  options.uimaConfig.programs.dev.direnv = {
    enable = mkEnableOption "Enables direnv";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      config.whitelist.prefix = [ "~/src" ];

      config.whitelist.exact = [ "~/nix" ];
    };
  };
}
