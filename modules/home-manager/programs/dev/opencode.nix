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
    uimaConfig.system.impermanence = {
      directories = [ ".local/share/opencode" ];
    };

    programs.opencode = {
      enable = true;

      themes.stylix.theme = {
        background = {
          dark = mkForce "none";
          light = mkForce "none";
        };
      };
    };
  };
}
