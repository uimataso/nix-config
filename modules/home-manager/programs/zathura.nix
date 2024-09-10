{
  config,
  lib,
  ...
}:
with lib;
# TODO: push default-bg and font to stylix
let
  cfg = config.uimaConfig.programs.zathura;

  mkRgba =
    color: opacity:
    let
      c = config.lib.stylix.colors;
      r = c."${color}-rgb-r";
      g = c."${color}-rgb-g";
      b = c."${color}-rgb-b";
    in
    "rgba(${r},${g},${b},${builtins.toString opacity})";
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

        default-bg = with config.stylix; mkForce (mkRgba "base00" opacity.applications);
        font = with config.stylix.fonts; "${monospace.name} ${builtins.toString sizes.terminal}";
      };
    };
  };
}
