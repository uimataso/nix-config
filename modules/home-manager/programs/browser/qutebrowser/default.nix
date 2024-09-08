{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.browser.qutebrowser;

  imper = config.uimaConfig.system.impermanence;
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
