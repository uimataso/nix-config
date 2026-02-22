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
      executable = "${config.xdg.stateHome}/nix/profile/bin/tofi";
    };

    programs.tofi = {
      enable = true;

      # man tofi.5
      settings = with config.lib.stylix.colors.withHashtag; {
        font-size = mkForce 15;

        selection-color = mkForce base00;
        selection-background = mkForce base05;
        selection-background-padding = "2, 8";
        selection-background-corner-radius = 5;

        width = "100%";
        height = "100%";

        border-width = 0;
        outline-width = 0;

        padding-left = "35%";
        padding-top = "35%";

        result-spacing = 15;

        hide-cursor = true;
        matching-algorithm = "fuzzy";
        num-results = 10;
      };
    };
  };
}
