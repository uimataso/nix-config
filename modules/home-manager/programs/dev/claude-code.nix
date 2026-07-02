{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.claude-code;
in
{
  options.uimaConfig.programs.dev.claude-code = {
    enable = mkEnableOption "claude-code";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".claude" ];
      files = [ ".claude.json" ];
    };

    programs.claude-code = {
      enable = true;

      # note: they don't follow xdg at all anyway :(
      # configDir = "${config.xdg.configHome}/claude";
    };
  };
}
