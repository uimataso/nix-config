{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.terminal.alacritty;
in
{
  options.uimaConfig.programs.terminal.alacritty = {
    enable = mkEnableOption "alacritty";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use alacritty as default terminal";
    };
  };

  config = mkIf cfg.enable {
    uimaConfig.programs.terminal = mkIf cfg.defaultTerminal {
      enable = true;
      executable = "alacritty";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 5;
            y = 5;
          };
        };
      };
    };
  };
}
