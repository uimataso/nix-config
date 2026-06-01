{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.pi-coding-agent;
in
{
  options.uimaConfig.programs.dev.pi-coding-agent = {
    enable = mkEnableOption "pi-coding-agent";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".config/pi" ];
    };

    home.packages = with pkgs; [
      pi-coding-agent
    ];

    home.sessionVariables = {
      PI_CODING_AGENT_DIR = "$HOME/.config/pi";
      PI_SKIP_VERSION_CHECK = "1";
    };
  };
}
