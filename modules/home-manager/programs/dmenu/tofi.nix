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
      executable = "${config.programs.tofi.package}/bin/tofi";
    };

    stylix.targets.tofi.enable = false;

    programs.tofi = {
      enable = true;

      # man tofi.5
      settings =
        with config.lib.stylix.colors.withHashtag;
        let
          opacity = lib.toHexString (((builtins.ceil (config.stylix.opacity.popups * 100)) * 255) / 100);

        in
        {
          font = config.stylix.fonts.monospace.name;
          font-size = 15;

          text-color = base04;
          input-color = base05;
          prompt-color = base05;
          background-color = base00 + opacity;

          selection-color = base00;
          selection-background = base05;
          selection-background-padding = "2, 8";
          selection-background-corner-radius = 5;

          width = "100%";
          height = "100%";

          border-width = 0;
          outline-width = 0;

          padding-left = "35%";
          padding-top = "35%";

          result-spacing = 15;

          fuzzy-match = true;
          num-results = 10;
        };
    };
  };
}
