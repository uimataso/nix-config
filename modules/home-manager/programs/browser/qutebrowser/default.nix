{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.programs.browser.qutebrowser;

  searchEngines = import ../search-engines.nix;
  trustedSites = import ../trusted-sites.nix;

  terminal = config.uimaConfig.programs.terminal.executable;
  editor = config.uimaConfig.programs.editor.executable;
in
{
  options.uimaConfig.programs.browser.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };

  # TODO: bitwarden

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".local/share/qutebrowser"
        ".config/qutebrowser/bookmarks"
      ];
      files = [ ".config/qutebrowser/quickmarks" ];
    };

    programs.qutebrowser = {
      enable = true;

      aliases = {
        q = "close";
        qa = "quit";
        w = "session-save";
        wq = "quit --save";
        wqa = "quit --save";
      };

      keyBindings = {
        normal = {
          j = "scroll-px 0 80";
          k = "scroll-px 0 -80";
          h = "scroll-px -80 0";
          l = "scroll-px 80 0";
          "<PgDown>" = "scroll-page 0 0.5";
          "<PgUp>" = "scroll-page 0 -0.5";

          "<Ctrl-i>" = "forward";
          "<Ctrl-o>" = "back";
          "<Ctrl-l>" = "clear-messages ;; download-clear";

          # reopen closed tab
          D = "undo";
          # focus on first input
          a = "hint -f inputs";
        };
      };

      settings = {
        completion.cmd_history_max_items = -1;
        content.autoplay = false;
        # TODO:
        # content.cookies.accept = "never";
        # content.javascript.enabled = false;
        downloads.position = "bottom";
        editor.command = [
          terminal
          editor
          "{file}"
        ];
        # TODO:
        # fileselect.folder.command
        # fileselect.multiple_files.command
        # fileselect.single_file.command
        # spellcheck.languages
        tabs.last_close = "close";
        tabs.mousewheel_switching = false;
        tabs.position = "left";
        url.default_page = "https://home.uimataso.com";
        url.start_pages = "https://home.uimataso.com";
        window.transparent = true;

        colors =
          let
            inherit (config.lib.stylix) colors mkOpacityHexColor;
            inherit (config.stylix) opacity;

            mkOpacityColor = color: alpha: "#${lib.removePrefix "0x" (mkOpacityHexColor color alpha)}";
            opacityColor = color: mkOpacityColor color opacity.applications;

            bg = colors.withHashtag.base00;
            fg = colors.withHashtag.base05;
          in
          {
            webpage.darkmode.enabled = true;

            tabs = {
              bar.bg = mkForce (opacityColor bg);
              even.bg = mkForce (opacityColor bg);
              odd.bg = mkForce (opacityColor bg);
            };
            completion = {
              even.bg = mkForce (opacityColor bg);
              odd.bg = mkForce (opacityColor bg);
            };
            messages = {
              info.bg = mkForce (opacityColor bg);
              info.fg = mkForce fg;
              info.border = mkForce bg;
            };
            statusbar = {
              normal.bg = mkForce (opacityColor bg);
              url.success.http.fg = mkForce fg;
              url.success.https.fg = mkForce fg;
            };
          };
      };

      extraConfig = /* py */ ''
        config.set("tabs.padding", {"bottom": 2, "left": 5, "right": 5, "top": 2})
        config.unbind("u")
      '';

      searchEngines = {
        DEFAULT = searchEngines.se.url;
      }
      // lib.attrsets.mapAttrs (key: val: val.url) searchEngines;

      perDomainSettings =
        let
          allowCookie = lib.attrsets.genAttrs trustedSites.allowCookie (domain: {
            content.cookies.accept = "no-unknown-3rdparty";
          });

          allowJavaScript = lib.attrsets.genAttrs trustedSites.allowJavaScript (domain: {
            content.javascript.enabled = true;
          });
        in
        lib.mkMerge [
          allowCookie
          allowJavaScript
        ];
    };
  };
}
