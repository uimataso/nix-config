{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.browser.firefox.profile.uima;

  name = "uima";

  color =
    with config.lib.stylix.colors.withHashtag;
    # css
    ''
      :root{
        --bg-color: ${base00} !important;
        --fg-color: ${base07} !important;
        --pr-color: ${base0E} !important;
      }
    '';

  searchEngines = {
    # Search
    "Searx" = {
      aliases = [ "@s" ];
      url = "https://search.uimataso.com/search?q={searchTerms}";
    };
    "DuckDuckGo" = {
      aliases = [ "@d" ];
      url = "https://duckduckgo.com/?q={searchTerms}";
    };
    "Google" = {
      aliases = [ "@g" ];
      url = "https://www.google.com/search?q={searchTerms}";
    };

    # Nix
    "Nix Packages" = {
      aliases = [ "@np" ];
      url = "https://search.nixos.org/packages?type=packages&query={searchTerms}";
    };
    "NixOS Wiki" = {
      aliases = [ "@nw" ];
      url = "https://nixos.wiki/index.php?search={searchTerms}";
    };
    "MyNixOS" = {
      aliases = [ "@mn" ];
      url = "https://mynixos.com/search?q={searchTerms}";
    };
    "Home Manager Options" = {
      aliases = [ "@hmo" ];
      url = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
    };

    # Dev
    "ArchWiki" = {
      aliases = [ "@aw" ];
      url = "https://wiki.archlinux.org/index.php?search={searchTerms}";
    };
    "Rust Std" = {
      aliases = [ "@ru" ];
      url = "https://doc.rust-lang.org/std/iter/?search={searchTerms}";
    };

    # Translation
    "Google Translate" = {
      aliases = [ "@gt" ];
      url = "https://translate.google.com/?text={searchTerms}";
    };
  };

  getFavicon =
    url:
    lib.strings.concatStrings (
      (builtins.elemAt (builtins.split "(https://[^/]*/).*" url) 1) ++ [ "favicon.ico" ]
    );

  mapEngine = engine: {
    definedAliases = engine.aliases;
    urls = [{ template = engine.url; }];
    iconUpdateURL = getFavicon engine.url;
    updateInterval = 24 * 60 * 60 * 1000;
  };

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.browser.firefox.profile.${name} = {
    enable = mkEnableOption "Firefox profile: ${name}";
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { directories = [ ".mozilla/firefox/${name}" ]; };

    programs.firefox = {
      profiles.${name} = {
        search = {
          force = true;
          default = "Searx";

          engines = lib.attrsets.mapAttrs (name: value: mapEngine value) searchEngines // {
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
          simplelogin
          vimium # TODO: manage setting, search engine
          # set new tab to home and focus on page instead of address bar
          new-tab-override

          # Youtube
          return-youtube-dislikes
          youtube-recommended-videos
          dearrow # clickbait remover

          # Translate via Google or DeepL
          simple-translate
          # Add Furigana (振り仮名) on Japanese kanji.
          furiganaize
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
          # Auto enable extensions
          "extensions.autoDisableScopes" = 0;

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
          "browser.tabs.inTitlebar" = 1;

          # Don't Ask to remember password
          "services.sync.prefs.sync.signon.rememberSignons" = false;
          "signon.rememberSignons" = false;
          "signon.rememberSignons.visibilityToggle" = false;

          # Try to remove view, didn't work
          "browser.tabs.firefox-view" = false;
          "browser.firefox-view.search.enabled" = false;
          "browser.firefox-view.view-count" = 0;

          # User chrome preferences
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
        };

        arkenfox = {
          enable = true;
          "0000".enable = true;
          "0100".enable = true;
          "0100"."0102"."browser.startup.page".value = 3;
          "0100"."0103"."browser.startup.homepage".value = "https://home.uimataso.com";
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
