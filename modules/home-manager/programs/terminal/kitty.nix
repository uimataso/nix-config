{ config
, lib
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.uimaConfig.programs.terminal.kitty;
in
{
  options.uimaConfig.programs.terminal.kitty = {
    enable = mkEnableOption "kitty";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use kitty as default terminal";
    };
  };

  config = mkIf cfg.enable {
    uimaConfig.programs.terminal = mkIf cfg.defaultTerminal {
      enable = true;
      executable = "kitty";
    };

    programs.kitty = {
      enable = true;
    };
  };
}
