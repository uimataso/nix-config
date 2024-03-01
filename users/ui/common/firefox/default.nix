{ inputs, pkgs, ... }:

# TODO:
# tailscale option (settings for non tailscale)
# firefox view (left toolbar)
# search suggest (settings dont works)
# cookie exceptions
# plugin settings
# user chrome
# exit botton
# bookmark (local or here)
# containers (use or not)
# vim keybind
# new page to home

{
  imports = [
    inputs.arkenfox.hmModules.default
  ];

  nixpkgs.overlays = [
    inputs.nur.overlay
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
  };

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

    profiles.ui = {
      search = {
        force = true;
        default = "Searx";
        order = [
          "Searx"
          "DuckDuckGo"
        ];

        engines = {
          "Searx" = {
            urls = [{
              template = "https://search.uima.duckdns.org/search?q={searchTerms}";
              iconUpdateURL = "https://searx.github.io/searx/_static/searx_logo_small.png";
              definedAliases = [ "@s" ];
            }];
          };
          "Google".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "Wikipedia".metaData.hidden = true;
        };
      };

      # $ nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        skip-redirect
        bitwarden
        darkreader
        i-dont-care-about-cookies
      ];

      # containers = {
      # };

      settings = {
        "identity.fxaccounts.enabled" = false;
        "extensions.pocket.enabled" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.tabs.tabmanager.enabled" = false;

        "browser.tabs.firefox-view" = false;
        "browser.firefox-view.search.enabled" = false;
        "browser.firefox-view.view-count" = 0;
      };

      arkenfox = {
        enable = true;
        "0000".enable = true;
        "0100".enable = true;
        "0100"."0102"."browser.startup.page".value = 3;
        "0100"."0103"."browser.startup.homepage".value = "dashboard.uima.duckdns.org";
        "0200".enable = true;
        "0300".enable = true;
        "0400".enable = true;
        "0600".enable = true;
        "0800".enable = true;
        "0900".enable = true;
        "1000".enable = true;
        "1200".enable = true;
        "1600".enable = true;
        "1700".enable = true;
        "2000".enable = true;
        "2400".enable = true;
        "2600".enable = true;
        "2600"."2651"."browser.download.useDownloadDir".enable = true;
        "2700".enable = true;
        "2800".enable = true;
        "4500".enable = false;
        "4500"."4501"."privacy.resistFingerprinting".enable = false;
        "5000".enable = true;
        "5500".enable = true;
        "5500"."5508"."media.eme.enabled".enable = true;
        "6000".enable = true;
        "7000".enable = true;
        "8000".enable = true;
        "9000".enable = true;
      };
    };
  };
}
