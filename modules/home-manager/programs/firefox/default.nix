{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
# NOTE: wish list for firefox
# [x] cookie exceptions
# [x] plugin settings
# [-] disable firefox view (left toolbar)
# bookmark (local or here)
# containers (use or not)
# vim keybind backup or auto sync
# vimium search engine, book mark...
with lib;
let
  cfg = config.uimaConfig.programs.firefox;
in
{
  options.uimaConfig.programs.firefox = {
    enable = mkEnableOption "Firefox";

    defaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = "Use firefox as default browser";
    };
  };

  imports = [
    ./profile_uima.nix
    inputs.arkenfox.hmModules.default
  ];

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

    home.sessionVariables = mkIf cfg.defaultBrowser { BROWSER = "firefox"; };

    programs.firefox = {
      enable = true;
      arkenfox = {
        enable = true;
        version = "126.0";
      };
    };
  };
}
