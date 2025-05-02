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
      executable = "${config.programs.foot.package}/bin/foot";
    };

    programs.foot = {
      enable = true;
      settings = with config.lib.stylix.colors; {
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
