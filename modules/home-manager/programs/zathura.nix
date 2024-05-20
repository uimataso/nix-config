{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.zathura;
in
{
  options.uimaConfig.programs.zathura = {
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

        # font = "MesloLGS Nerd Font 11";
      };
    };
  };
}
