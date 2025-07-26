{
  config,
  lib,
  pkgs,
  ...
}:

# TODO:
# - [ ] plugin settings
#   - For uBlock settings, look [here](https://github.com/Kreyren/nixos-config/blob/bd4765eb802a0371de7291980ce999ccff59d619/nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix#L116-L148)
#   - Setup bitwarden host url
# - [ ] remove suggested items when search

let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.browser.librewolf;

  searchEngines = import ../search-engines.nix;

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
    uimaConfig.system.impermanence = {
      # directories = [ ".mozilla/firefox/${config.programs.firefox.profiles.${profileName}.path}" ];
      directories = [ ".librewolf/${config.programs.librewolf.profiles.${profileName}.path}" ];
    };

    uimaConfig.programs.browser = mkIf cfg.defaultBrowser {
      enable = true;
      executable = "${config.xdg.stateHome}/nix/profile/bin/librewolf";
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
            "https://porkbun.com"

            "https://accounts.google.com"
            "https://google.com"
            "https://youtube.com"

            "https://github.com"
            "https://tailscale.com"
            "https://mynixos.com"

            "https://leetcode.com"
            "https://codeforces.com"
            "https://reddit.com"
            "https://printables.com"

            "https://monkeytype.com"
            "https://typ.ing"
            "https://shurufa.app"

            "https://aws.amazon.com"
            "https://chatgpt.com"
            "https://figma.com"
            "https://cloudflare.com"
            "https://www.notion.so"
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
          default = "s";

          engines =
            let
              getFavicon =
                url:
                lib.strings.concatStrings (
                  (builtins.elemAt (builtins.split "(https://[^/]*/).*" url) 1) ++ [ "favicon.ico" ]
                );

              mapEngine = key: val: {
                name = val.name;
                definedAliases = [ "${key}" ];
                urls = [ { template = builtins.replaceStrings [ "{}" ] [ "{searchTerms}" ] val.url; } ];
                icon = getFavicon val.url;
                updateInterval = 24 * 60 * 60 * 1000;
              };
            in
            lib.attrsets.mapAttrs mapEngine searchEngines
            // {
              # FIXME: disable default engines
              bing.metaData.hidden = true;
              wikipedia.metaData.hidden = true;
            };
        };

        # $ nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          simplelogin
          ublock-origin
          darkreader
          vimium
          sidebery

          skip-redirect
          istilldontcareaboutcookies

          return-youtube-dislikes
          youtube-recommended-videos
          dearrow # clickbait remover

          new-tab-override # set new tab to custom url and focus to page instead of address bar
          furiganaize # add Furigana (振り仮名) on Japanese kanji.
          yomitan
        ];

        containersForce = true;
        containers = {
          self = {
            id = 1;
            color = "blue";
            icon = "circle";
          };
          google = {
            id = 2;
            color = "yellow";
            icon = "fence";
          };
          araizen = {
            id = 3;
            color = "orange";
            icon = "briefcase";
          };
        };

        userChrome = lib.strings.concatLines [
          userCssColor
          (builtins.readFile ./chrome/userChrome.css)
          # (builtins.readFile ./chrome/onebar.css)
          (builtins.readFile ./chrome/sidebery.css)
          (builtins.readFile ./chrome/navbar_below_content.css)
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
