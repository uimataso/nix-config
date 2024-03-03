{ config, inputs, pkgs, lib, ... }:

let
  palette = config.colorScheme.palette;
  color = ''
    :root{
      --bg-color: #${palette.base00} !important;
      --fg-color: #${palette.base0F} !important;
      --pr-color: #${palette.base05} !important;
      --bg-90tran: color-mix(in srgb, var(--bg-color) 90%, transparent);
      --pr-90tran: color-mix(in srgb, var(--pr-color) 90%, transparent);
    }
  '';
in {
  programs.firefox = {
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

      userChrome = lib.strings.concatLines [
        color
        (builtins.readFile ./chrome/userChrome.css)
        (builtins.readFile ./chrome/onebar.css)
      ];

      userContent = lib.strings.concatLines [
        color
        (builtins.readFile ./content/userContent.css)
        (builtins.readFile ./content/newtab_background.css)
        (builtins.readFile ./content/youtube.css)
        (builtins.readFile ./content/hacker_news.css)
      ];

      settings = {
        "identity.fxaccounts.enabled" = false;
        "extensions.pocket.enabled" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.tabs.tabmanager.enabled" = false;

        # Try to remove view, didn't work
        "browser.tabs.firefox-view" = false;
        "browser.firefox-view.search.enabled" = false;
        "browser.firefox-view.view-count" = 0;

        # User chrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;

        # Compact mode
        "browser.uidensity" = 1;
        # not title bar
        "browser.tabs.inTitlebar" = 0;
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
