{ config
, lib
, ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.terminal.foot;
in
{
  options.uimaConfig.programs.terminal.foot = {
    enable = mkEnableOption "foot";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use foot as default terminal";
    };
  };

  config = mkIf cfg.enable {
    uimaConfig.programs.terminal = mkIf cfg.defaultTerminal {
      enable = true;
      executable = "foot";
    };

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
  };
}
