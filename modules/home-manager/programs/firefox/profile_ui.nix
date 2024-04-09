{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.myConfig.programs.firefox.profile.ui;

  palette = config.colorScheme.palette;
  color = ''
    :root{
      --bg-color: #${palette.base00} !important;
      --fg-color: #${palette.base0F} !important;
      --pr-color: #${palette.base05} !important;
    }
  '';
in
{
  options.myConfig.programs.firefox.profile.ui = {
    enable = mkEnableOption "Firefox profile: ui";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      profiles.ui = {
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
          bitwarden
          darkreader
          i-dont-care-about-cookies
          vimium
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
          "6000".enable = true;
          # "7000".enable = true;
          # "8000".enable = true;
          "9000".enable = true;
        };
      };
    };
  };
}

# vimium:
# unmapAll
# map j scrollDown
# map k scrollUp
# map h scrollLeft
# map l scrollRight
# map gg scrollToTop
# map G scrollToBottom
# map <c-d> scrollPageDown
# map <PageUp> scrollPageUp
# map <PageDown> scrollPageDown
#
# map r reload
# map yy copyCurrentUrl
# map p openCopiedUrlInCurrentTab
# map P openCopiedUrlInNewTab
# map o Vomnibar.activate
# map O Vomnibar.activateInNewTab
# map f LinkHints.activateMode
# map F LinkHints.activateModeToOpenInNewForegroundTab
# map <c-f> LinkHints.activateModeToOpenInNewTab
#
# map i enterInserMode
# map v enterVisualMode
# map a focusInput
# map / enterFindMode
# map n performFind
# map N performBackwardsFind
#
# map gf nextFrame
# map gF mainFame
#
# map H goBack
# map <c-o> goBack
# map L goForward
# map <c-i> goForward
#
# map t createTab
# map b previousTab
# map w nextTab
# map " visitPreviousTab
# map g0 firstTab
# map g$ lastTab
# map yt duplicateTab
# map d removeTab
# map D restoreTab
#
# search engines
# s: https://search.uima.duckdns.org/search?q=%s
# np: https://search.nixos.org/packages?type=packages&query=%s
# nw: https://nixos.wiki/index.php?search=%s
# nm: https://mynixos.com/search?q=%s
# aw: https://wiki.archlinux.org/index.php?search=%s
# ru: https://doc.rust-lang.org/std/iter/?search=%s
