{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.browser.vimiumOptions;

  searchEngines = import ./search-engines.nix;
in
{
  options.uimaConfig.programs.browser.vimiumOptions = {
    enable = mkEnableOption "vimium-options";
  };

  imports = [
    inputs.vimium-options.homeManagerModules.vimium-options
  ];

  config = mkIf cfg.enable {
    home.vimiumOptions = {
      enable = true;

      exclusionRules = [
        {
          passKeys = "";
          pattern = "https?://mail.google.com/*";
        }
        {
          passKeys = "";
          pattern = "https?://monkeytype.com/*";
        }
      ];

      keyMappings = {
        unmapAll = true;
        map = {
          j = "scrollDown";
          k = "scrollUp";
          h = "scrollLeft";
          l = "scrollRight";
          gg = "scrollToTop";
          G = "scrollToBottom";
          "<c-u>" = "scrollPageUp";
          "<c-d>" = "scrollPageDown";
          "<c-b>" = "scrollPageUp";
          "<PageUp>" = "scrollPageUp";
          "<PageDown>" = "scrollPageDown";

          r = "reload";
          yy = "copyCurrentUrl";
          yf = "LinkHints.activateMode action=copy-text";
          p = "openCopiedUrlInCurrentTab";
          P = "openCopiedUrlInNewTab";
          o = "Vomnibar.activate";
          O = "Vomnibar.activateInNewTab";
          f = "LinkHints.activateMode";
          F = "LinkHints.activateModeToOpenInNewForegroundTab";
          #<c-f> ="LinkHints.activateModeToOpenInNewTab";

          i = "enterInsertMode";
          v = "enterVisualMode";
          a = "focusInput";
          "/" = "enterFindMode";
          n = "performFind";
          N = "performBackwardsFind";

          gf = "nextFrame";
          # gF = "mainFame";

          H = "goBack";
          "<c-o>" = "goBack";
          L = "goForward";
          "<c-i>" = "goForward";

          t = "createTab";
          b = "previousTab";
          w = "nextTab";
          "\"" = "visitPreviousTab";
          g0 = "firstTab";
          "g$" = "lastTab";
          yt = "duplicateTab";
          d = "removeTab";
          D = "restoreTab";
        };
      };

      searchEngines = lib.attrsets.mapAttrs (
        key: val: "${builtins.replaceStrings [ "{}" ] [ "%s" ] val.url} ${val.name}"
      ) searchEngines;

      userDefinedLinkHintCss =
        let
          colors = config.lib.stylix.colors.withHashtag;
        in
        # css
        ''
          div > .vimiumHintMarker {
            /* linkhint boxes */
            background: ${colors.base0A};
            border: 1px solid ${colors.base0A};
          }

          div > .vimiumHintMarker span {
            /* linkhint text */
            color: ${colors.base00};
            font-weight: bold;
            font-size: 12px;
            text-shadow: none !important;
          }

          div > .vimiumHintMarker > .matchingCharacter {
          }

          #vomnibar,
          #vomnibar input,
          #vomnibar #vomnibar-search-area,
          #vomnibar ul,
          #vomnibar li {
            color: ${colors.base05} !important;
            background-color: ${colors.base00} !important;
            border: 0px !important;
          }

          #vomnibar {
            padding: 1px !important;

            #vomnibar-search-area {
              padding: 5px !important;
              border-bottom: 2px solid ${colors.base05} !important;
            }

            li.selected {
              background-color: ${colors.base01} !important;
            }

            li {
              em,
              .title,
              .relevancy {
                color: ${colors.base05} !important;
              }

              .source,
              em .match {
                color: ${colors.base04} !important;
              }

              .match,
              .title .match {
                color: ${colors.base06} !important;
              }

              .url {
                color: ${colors.base0D} !important;
              }
            }
          }
        '';
    };
  };
}
