{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.fzf;

  # scheme = config.scheme;
in
{
  options.uimaConfig.sh-util.fzf = {
    enable = mkEnableOption "fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;

      defaultOptions = [
        "--height 50%"
        "--no-separator"
        "--info=inline"
        "--reverse"
        "--bind=tab:down"
        "--bind=pgup:preview-up"
        "--bind=pgdn:preview-down"
      ];

      defaultCommand = "fd -HL --exclude '.git' --type file";

      colors = {
        bg = "-1";
        gutter = "-1";
      };
    };
  };
}
