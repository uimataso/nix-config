{ config, lib, pkgs, inputs, ... }:

# TODO: wish list for firefox
# [x] cookie exceptions
# [x] plugin settings
# [-] firefox view (left toolbar)
# [-] search suggest (settings dont works)
# bookmark (local or here)
# containers (use or not)
# vim keybind
# vimium search engine, book mark...
# new page to home

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

    home.sessionVariables = mkIf cfg.defaultBrowser {
      BROWSER = "firefox";
    };

    programs.firefox = {
      enable = true;
      arkenfox = {
        enable = true;
        # version = "123.0";
      };
    };
  };
}
