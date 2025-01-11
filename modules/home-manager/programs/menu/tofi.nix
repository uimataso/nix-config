{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkForce
    types
    ;
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
    uimaConfig.programs.menu = mkIf cfg.defaultMenu {
      enable = true;
      executable = "tofi";
    };

    programs.tofi = {
      enable = true;

      # main tofi.5
      settings = with config.lib.stylix.colors.withHashtag; {
        font-size = mkForce 20;
        selection-color = mkForce base0A;

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
