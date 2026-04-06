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
      executable = "${config.xdg.stateHome}/nix/profile/bin/foot";
    };

    home.shellAliases = {
      ssh = "env TERM=xterm-256color ssh";
    };

    programs.foot = {
      enable = true;

      settings = {
        main = {
          pad = "5x3";
        };
        colors-dark = with config.lib.stylix.colors; {
          cursor = "${base00}  ${base05}";
        };

        key-bindings = {
          # unbind <C-S-n>
          spawn-terminal = "none";
        };
      };
    };
  };
}
