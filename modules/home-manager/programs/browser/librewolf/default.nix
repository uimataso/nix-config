{
  config,
  lib,
  pkgs,
  ...
}:

# TODO:
# - [ ] plugin settings
#   - For uBlock settings, look [here](https://github.com/Kreyren/nixos-config/blob/bd4765eb802a0371de7291980ce999ccff59d619/nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix#L116-L148)
# - [ ] remove suggested items when search

let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.browser.librewolf;

  profileName = "uima";

  userCssColor =
    with config.lib.stylix.colors.withHashtag;
    with config.stylix;
    let
      trans = builtins.toString (builtins.floor (opacity.applications * 100));
    in
    # css
    ''
      :root{
        --base00: ${base00}; --base01: ${base01}; --base02: ${base02}; --base03: ${base03};
        --base04: ${base04}; --base05: ${base05}; --base06: ${base06}; --base07: ${base07};
        --base08: ${base08}; --base09: ${base09}; --base0A: ${base0A}; --base0B: ${base0B};
        --base0C: ${base0C}; --base0D: ${base0D}; --base0E: ${base0E}; --base0F: ${base0F};
        --base00-trans: color-mix(in srgb, var(--base00) ${trans}%, transparent);
        --bg: transparent;

        --t: #00ff00;
      }
    '';

  searchEngines = {
    searx = {
      name = "Searx";
      aliases = [ "@s" ];
      url = "https://search.uimataso.com/search?q={searchTerms}";
    };
    ddg = {
      name = "DuckDuckGo";
      aliases = [ "@d" ];
      url = "https://duckduckgo.com/?q={searchTerms}";
    };
    google = {
      name = "Google";
      aliases = [ "@g" ];
      url = "https://www.google.com/search?q={searchTerms}";
    };

    nix-packages = {
      name = "Nix Packages";
      aliases = [ "@np" ];
      url = "https://search.nixos.org/packages?type=packages&query={searchTerms}";
    };
    nixos-wiki = {
      name = "NixOS Wiki";
      aliases = [ "@nw" ];
      url = "https://nixos.wiki/index.php?search={searchTerms}";
    };
    mynixos = {
      name = "MyNixOS";
      aliases = [ "@mn" ];
      url = "https://mynixos.com/search?q={searchTerms}";
    };
    home-manager-options = {
      name = "Home Manager Options";
      aliases = [ "@hmo" ];
      url = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
    };

    arch-wiki = {
      name = "ArchWiki";
      aliases = [ "@aw" ];
      url = "https://wiki.archlinux.org/index.php?search={searchTerms}";
    };
    rust-std = {
      name = "Rust Std";
      aliases = [ "@ru" ];
      url = "https://doc.rust-lang.org/std/iter/?search={searchTerms}";
    };

    google-translate = {
      name = "Google Translate";
      aliases = [ "@gt" ];
      url = "https://translate.google.com/?text={searchTerms}";
    };
  };
in
{
  options.uimaConfig.programs.browser.librewolf = {
    enable = mkEnableOption "LibreWolf";

    defaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = "Use librewolf as default browser";
    };
  };

  config = mkIf cfg.enable {
    # uimaConfig.system.impermanence = {
    #   directories = [ ".mozilla/firefox/${config.programs.firefox.profiles.${profileName}.path}" ];
    # };
    uimaConfig.system.impermanence = {
      directories = [ ".librewolf/${config.programs.librewolf.profiles.${profileName}.path}" ];
    };

    uimaConfig.programs.browser = mkIf cfg.defaultBrowser {
      enable = true;
      executable = "librewolf";
      desktop = "librewolf.desktop";
    };

    stylix.targets.librewolf.profileNames = [ profileName ];

    programs.librewolf = {
      enable = true;

      policies = {
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisableForgetButton = true; # what is forget button??
        DisablePocket = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        DontCheckDefaultBrowser = true;
        OfferToSaveLoginsDefault = false;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;

        # TODO: clean cookies for each container?
        Cookies = {
          Behavior = "reject";
          Allow = [
            "https://uimataso.com"

            "https://proton.me"
            "https://simplelogin.io"

            "https://accounts.google.com"
            "https://www.google.com"
            "https://www.youtube.com"

            "https://tailscale.com"
            "https://porkbun.com"
            "https://github.com"
            "https://mynixos.com"
            "https://chatgpt.com"
            "https://leetcode.com"
            "https://codeforces.com"
            "https://monkeytype.com"
            "https://typ.ing"
            "https://www.reddit.com"
            "https://www.printables.com"
            "https://shurufa.app"
          ];
        };

        # TODO: try setting extension with this
        # "3rdparty" = {
        #   Extensions = {
        #     "uBlock0@raymondhill.net" = { };
        #   };
        # };
      };

      profiles.${profileName} = {
        search = {
          force = true;
          default = "Searx";

          engines =
            let
              getFavicon =
                url:
                lib.strings.concatStrings (
                  (builtins.elemAt (builtins.split "(https://[^/]*/).*" url) 1) ++ [ "favicon.ico" ]
                );

              mapEngine = engine: {
                name = engine.name;
                definedAliases = engine.aliases;
                urls = [ { template = engine.url; } ];
                icon = getFavicon engine.url;
                updateInterval = 24 * 60 * 60 * 1000;
              };
            in
            lib.attrsets.mapAttrs (name: value: mapEngine value) searchEngines
            // {
              "bing".metaData.hidden = true;
              "wikipedia".metaData.hidden = true;
            };
        };

        # $ nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          simplelogin
          ublock-origin
          darkreader
          vimium

          skip-redirect
          istilldontcareaboutcookies

          return-youtube-dislikes
          youtube-recommended-videos
          dearrow # clickbait remover

          new-tab-override # set new tab to custom url and focus to page instead of address bar
          furiganaize # add Furigana (振り仮名) on Japanese kanji.
        ];

        containersForce = true;
        containers = {
          self = {
            id = 1;
            color = "blue";
            icon = "circle";
          };
          work = {
            id = 2;
            color = "orange";
            icon = "briefcase";
          };
        };

        userChrome = lib.strings.concatLines [
          userCssColor
          (builtins.readFile ./chrome/userChrome.css)
          (builtins.readFile ./chrome/onebar.css)
        ];

        userContent = lib.strings.concatLines [
          userCssColor
          (builtins.readFile ./content/userContent.css)
        ];

        settings = {
          # Auto enable extensions
          "extensions.autoDisableScopes" = 0;

          # Restore previous session
          "browser.startup.page" = 3;
          # Homepage
          "browser.startup.homepage" = "home.uimataso.com";

          # Disable firefox account
          "identity.fxaccounts.enabled" = false;
          # Disable pocket
          "extensions.pocket.enabled" = false;
          # Don't check is default browser
          "browser.shell.checkDefaultBrowser" = false;
          # Disable tabs in settings page
          "browser.preferences.moreFromMozilla" = false;
          # Disable List all tabs arrow in tab bar
          # "browser.tabs.tabmanager.enabled" = false;
          # Never show bookmark bar
          "browser.toolbars.bookmarks.visibility" = "never";
          # Disable title bar
          "browser.tabs.inTitlebar" = 1;
          # Don't Ask to remember password
          "services.sync.prefs.sync.signon.rememberSignons" = false;
          "signon.rememberSignons" = false;
          "signon.rememberSignons.visibilityToggle" = false;

          # Compact mode
          "browser.uidensity" = 1;
          # Transparent page
          "browser.tabs.allow_transparent_browser" = true;

          # User chrome preferences
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
        };
      };
    };
  };
}
