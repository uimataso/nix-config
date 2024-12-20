{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.programs.sh-util.fzf;
in
{
  options.uimaConfig.programs.sh-util.fzf = {
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

      colors = with config.lib.stylix.colors.withHashtag; {
        bg = mkForce "-1";
        gutter = mkForce "-1";
        prompt = mkForce base0B;
      };
    };

    home.shellAliases = {
      ef = "fzf | xargs -r $EDITOR";
    };

    programs.nushell = {
      extraConfig = "def fzf-editor [] { fzf | xargs -r $env.EDITOR }";
      shellAliases.ef = "fzf-editor";
    };
  };
}
