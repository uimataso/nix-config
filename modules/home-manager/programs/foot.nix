{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.foot;
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
      settings = with config.stylix.base16Scheme; {
        main = {
          pad = "5x3";
        };
        cursor = {
          color = "${base00}  ${base05}";
        };
      };
    };

    home.sessionVariables = mkIf cfg.defaultTerminal { TERMINAL = "foot"; };
  };
}
