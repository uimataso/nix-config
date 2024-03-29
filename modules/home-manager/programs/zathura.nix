{ config, lib, pkgs, ... }:

# TODO: theme support

with lib;

let
  cfg = config.myConfig.programs.zathura;

  palette = config.colorScheme.palette;
in {
  options.myConfig.programs.zathura = {
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

        font = "MesloLGS Nerd Font 11";
        default-bg = "rgba(18,18,18,0.85)";
        default-fg = "#d0d0d0";

        statusbar-bg = "#121212";
        statusbar-fg = "#d0d0d0";

        highlight-color = "#ebcb8b";
        highlight-active-color = "#81a1c1";

        completion-bg = "#121212";
        completion-fg = "#d0d0d0";

        notification-bg = "#121212";
        notification-fg = "#d0d0d0";

        recolor-lightcolor = "rgba(18,18,18,0.75)";
        recolor-darkcolor = "#cccccc";
        # keep original color
        recolor-keephue = true;
      };
    };
  };
}
