{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.programs.dev.opencode;
in
{
  options.uimaConfig.programs.dev.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;

      themes.stylix.theme = {
        background = {
          dark = mkForce "none";
          light = mkForce "none";
        };
        backgroundPanel = {
          dark = mkForce "none";
          light = mkForce "none";
        };
      };
    };
  };
}
