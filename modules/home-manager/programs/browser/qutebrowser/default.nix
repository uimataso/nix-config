{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.browser.qutebrowser;
in
{
  options.uimaConfig.programs.browser.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
    };
  };
}
