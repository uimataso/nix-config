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
  cfg = config.uimaConfig.programs.dmenu.tofi;
in
{
  options.uimaConfig.programs.dmenu.tofi = {
    enable = mkEnableOption "tofi";

    defaultDmenu = mkOption {
      type = types.bool;
      default = false;
      description = "Use tofi as default dmenu";
    };
  };

  config = mkIf cfg.enable {
    uimaConfig.programs.dmenu = mkIf cfg.defaultDmenu {
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
