{ config, lib, pkgs, inputs, ... }:

# Cookie Exceptions
# - https://uima.duckdns.org
# - https://accounts.google.com
# - https://www.google.com
# - https://www.youtube.com
# - https://proton.me
# - https://chatgpt.com
# - https://github.com
# - https://mynixos.com
# - https://www.reddit.com
# - https://leetcode.com
# - https://www.printables.com

with lib;

let
  cfg = config.uimaConfig.programs.firefox.profile.uima;

  scheme = config.stylix.base16Scheme;

  name = "uima";

  color = /*css*/ ''
    :root{
      --bg-color: #${scheme.base00} !important;
      --fg-color: #${scheme.base07} !important;
      --pr-color: #${scheme.base0E} !important;
    }
  '';

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.firefox.profile.${name} = {
    enable = mkEnableOption "Firefox profile: ${name}";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [ ".mozilla/firefox/${name}" ];
    };

    programs.firefox = {
      profiles.${name} = {
        search = {
          force = true;
          default = "Searx";

          engines = {
            "Searx" = {
              definedAliases = [ "@s" ];
              urls = [{ template = "https://search.uima.duckdns.org/search?q={searchTerms}"; }];
              iconUpdateURL = "https://search.uima.duckdns.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };

            "Nix Packages" = {
              definedAliases = [ "@np" ];
              urls = [{ template = "https://search.nixos.org/packages?type=packages&query={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };

            "NixOS Wiki" = {
              definedAliases = [ "@nw" ];
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };

            "MyNixOS" = {
              definedAliases = [ "@nm" ];
              urls = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
              iconUpdateURL = "https://mynixos.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };

            "ArchWiki" = {
              definedAliases = [ "@aw" ];
              urls = [{ template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };

            "Rust Std" = {
              definedAliases = [ "@ru" ];
              urls = [{ template = "https://doc.rust-lang.org/std/iter/?search={searchTerms}"; }];
              iconUpdateURL = "https://doc.rust-lang.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };

            "Google".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "Wikipedia (en)".metaData.hidden = true;
          };
        };

        # $ nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          skip-redirect
          i-dont-care-about-cookies

          darkreader
          bitwarden
          vimium # TODO: manage setting, search engine
          # set new tab to home and focus on page instead of address bar
          new-tab-override

          # Youtube
          return-youtube-dislikes
          youtube-recommended-videos
          dearrow # clickbait remover
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
          # Disable firefox account
          "identity.fxaccounts.enabled" = false;
          # Disable pocket
          "extensions.pocket.enabled" = false;
          # Disable tabs in settings page
          "browser.preferences.moreFromMozilla" = false;
          # Disable List all tabs arrow in tab bar
          "browser.tabs.tabmanager.enabled" = false;
          # Never show bookmark bar
          "browser.toolbars.bookmarks.visibility" = "never";
          # Dard theme
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          # Compact mode
          "browser.uidensity" = 1;
          # Disable title bar
          "browser.tabs.inTitlebar" = 0;

          # Don't Ask to remember password
          "services.sync.prefs.sync.signon.rememberSignons" = false;
          "signon.rememberSignons" = false;
          "signon.rememberSignons.visibilityToggle" = false;

          # Try to remove view, didn't work
          "browser.tabs.firefox-view" = false;
          "browser.firefox-view.search.enabled" = false;
          "browser.firefox-view.view-count" = 0;

          # User chrome
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
        };

        arkenfox = {
          enable = true;
          "0000".enable = true;
          "0100".enable = true;
          "0100"."0102"."browser.startup.page".value = 3;
          "0100"."0103"."browser.startup.homepage".value = "https://dashboard.uima.duckdns.org";
          "0200".enable = true;
          "0300".enable = true;
          # "0400".enable = true;
          "0600".enable = true;
          # "0700".enable = true;
          "0800".enable = true;
          "0900".enable = true;
          "1000".enable = true;
          "1200".enable = true;
          "1200"."1212"."security.OCSP.require".enable = false;
          "1600".enable = true;
          "1700".enable = true;
          "2000".enable = true;
          "2400".enable = true;
          "2600".enable = true;
          "2600"."2651"."browser.download.useDownloadDir".enable = true;
          "2700".enable = true;
          "2800".enable = true;
          # "4500".enable = true;
          # "5000".enable = true;
          # "5500".enable = true;
          # "6000".enable = true;
          # "7000".enable = true;
          # "8000".enable = true;
          "9000".enable = true;
        };
      };
    };
  };
}
