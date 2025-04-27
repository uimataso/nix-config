{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
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
          dynamic_title = true;
          padding = {
            x = 5;
            y = 5;
          };
        };
      };
    };
  };
}
