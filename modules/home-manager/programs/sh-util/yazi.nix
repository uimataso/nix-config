{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.yazi;
in
{
  options.uimaConfig.programs.sh-util.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;

      shellWrapperName = "f";

      theme =
        let
          square = {
            open = "▐";
            close = "▌";
          };
        in
        {
          indicator = {
            padding = square;
          };
          tabs = {
            sep_inner = square;
            sep_outer = square;
          };
          status = {
            sep_left = square;
            sep_right = square;
          };
        };
    };
  };
}
