{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.foot;

  scheme = config.stylix.base16Scheme;
in
{
  options.uimaConfig.programs.foot = {
    enable = mkEnableOption "foot";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use foot as default terminal";
    };
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          pad = "5x3";
        };
        cursor = {
          color = "${scheme.base00}  ${scheme.base05}";
        };
      };
    };

    home.sessionVariables = mkIf cfg.defaultTerminal { TERMINAL = "foot"; };
  };
}
