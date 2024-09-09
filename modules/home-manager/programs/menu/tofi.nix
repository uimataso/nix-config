{
  config,
  lib,
  pkgs,
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
      description = "Use tofi as default dmenu";
    };
  };

  config = mkIf cfg.enable {
    programs.tofi = {
      enable = true;
      settings = {
        background-color = mkForce "#000A";

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

    home.sessionVariables = mkIf cfg.defaultMenu { DMENU = "tofi"; };
  };
}
