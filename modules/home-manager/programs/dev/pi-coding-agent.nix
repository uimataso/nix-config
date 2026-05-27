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
    # uimaConfig.system.impermanence = {
    #   directories = [ ".local/share/opencode" ];
    # };

    home.packages = with pkgs; [
      pi-coding-agent
    ];
  };
}
