{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.aws-cli;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.dev.aws-cli = {
    enable = mkEnableOption "AWS CLI 2";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        "${config.xdg.configHome}/aws"
      ];
    };

    home.packages = with pkgs; [
      awscli2
    ];

    home.sessionVariables = {
      AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";
    };
  };
}
