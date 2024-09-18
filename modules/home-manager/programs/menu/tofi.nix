{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.menu.tofi;
in
{
  options.uimaConfig.programs.menu.tofi = {
    enable = mkEnableOption "tofi";

    # TODO: make a value that can setting default app-luncher AND dmenu
    defaultMenu = mkOption {
      type = types.bool;
      default = false;
      description = "Use tofi as default menu";
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.tofi.enable = false;

    uimaConfig.programs.menu = mkIf cfg.defaultMenu {
      enable = true;
      executable = "tofi";
    };

    programs.tofi = {
      enable = true;

      # main tofi.5
      settings = with config.lib.stylix.colors.withHashtag; {
        font = config.stylix.fonts.monospace.name;
        font-size = 20;

        background-color = "#000A";
        text-color = base05;
        prompt-color = base0E;
        selection-color = base0E;
        selection-background = base01;
        selection-background-padding = 4;
        selection-background-corner-radius = 4;

        width = "100%";
        height = "100%";

        border-width = 0;
        outline-width = 0;

        padding-left = "35%";
        padding-top = "35%";

        result-spacing = 15;
        num-results = 10;
      };
    };
  };
}
