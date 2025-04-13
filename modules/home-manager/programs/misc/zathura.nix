{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.zathura;
in
{
  options.uimaConfig.programs.misc.zathura = {
    enable = mkEnableOption "zathura";
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;

      mappings = {
        i = "recolor";
        r = "reload";
        R = "rotate";
      };

      options = {
        page-padding = 5;

        window-title-basename = "true";
        selection-clipboard = "clipboard";

        adjust-open = "width";
        # adjust-open = "best-fit";

        scroll-step = 50;

        recolor = true;

        font = with config.stylix.fonts; "${monospace.name} ${builtins.toString sizes.terminal}";
      };
    };
  };
}
