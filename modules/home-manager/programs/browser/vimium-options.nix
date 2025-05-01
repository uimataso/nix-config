{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.browser.vimiumOptions;
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

      keyMappings = {
        unmapAll = true;
        map = {
          j = "scrollDown";
          k = "scrollUp";
          h = "scrollLeft";
          l = "scrollRight";
          gg = "scrollToTop";
          G = "scrollToBottom";
          "<c-d>" = "scrollPageDown";
          "<PageUp>" = "scrollPageUp";
          "<PageDown>" = "scrollPageDown";

          r = "reload";
          yy = "copyCurrentUrl";
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

      searchEngines = {
        s = "https://search.uimataso.com/search?q=%s Searx";
        np = "https://search.nixos.org/packages?type=packages&query=%s NixOS Search - Packages";
        nm = "https://mynixos.com/search?q=%s MyNixOS";

        nw = "https://nixos.wiki/index.php?search=%s NixOS Wiki";
        aw = "https://wiki.archlinux.org/index.php?search=%s Arch Wiki";
        gw = "https://wiki.gentoo.org/index.php?title=Special%3ASearch&search=%s&go=Go Gentoo Wiki";

        ru = "https://doc.rust-lang.org/std/iter/?search=%s Rust Std";

        w = "https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s Wikipedia";
        g = "https://www.google.com/search?q=%s Google";
        y = "https://www.youtube.com/results?search_query=%s Youtube";
        gm = "https://www.google.com/maps?q=%s Google maps";
        d = "https://duckduckgo.com/?q=%s DuckDuckGo";
      };

      userDefinedLinkHintCss = # css
        ''
          div > .vimiumHintMarker {
          /* linkhint boxes */
          background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFF785),
            color-stop(100%,#FFC542));
          border: 1px solid #E3BE23;
          }

          div > .vimiumHintMarker span {
          /* linkhint text */
          color: black;
          font-weight: bold;
          font-size: 12px;
          }

          div > .vimiumHintMarker > .matchingCharacter {
          }
        '';
    };
  };
}
