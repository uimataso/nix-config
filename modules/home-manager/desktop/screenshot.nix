{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.screenshot;
in
{
  options.uimaConfig.desktop.screenshot = {
    enable = mkEnableOption "screenshot";

    outputDir = mkOption {
      type = types.string;
      default = "${config.xdg.pictures}/screenshots";
      description = ''
        Directory to store screenshots.
      '';
    };
  };

  config = mkIf cfg.enable {
    # todo
  };
}