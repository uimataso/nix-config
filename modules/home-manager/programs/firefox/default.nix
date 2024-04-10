{ config, lib, pkgs, inputs, ... }:

# TODO:
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
  cfg = config.myConfig.programs.firefox;
in
{
  options.myConfig.programs.firefox = {
    enable = mkEnableOption "Firefox";
  };

  imports = [
    ./profile_ui.nix
    inputs.arkenfox.hmModules.default
  ];

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
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
