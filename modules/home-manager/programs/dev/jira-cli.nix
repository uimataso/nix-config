{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.jira-cli;
in
{
  options.uimaConfig.programs.dev.jira-cli = {
    enable = mkEnableOption "jira-cli";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".config/.jira" ];
    };

    home.sessionVariables = {
      NETRC = "${config.xdg.configHome}/.jira/netrc";
    };

    home.packages = with pkgs; [
      jira-cli-go
    ];

    programs.bash.initExtra = ''
      jira() { NETRC="$HOME/.config/.jira/netrc" command jira "$@"; }
    '';
  };
}
