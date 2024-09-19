{ config
, lib
, ...
}:
with lib;
let
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
