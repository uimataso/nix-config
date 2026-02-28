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

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".local/share/qutebrowser" ];
    };

    programs.qutebrowser = {
      enable = true;

      # TODO: keybind

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
          in
          {
            webpage.darkmode.enabled = true;

            statusbar.normal.bg = mkForce (opacityColor bg);
            tabs.bar.bg = mkForce (opacityColor bg);
            tabs.even.bg = mkForce (opacityColor bg);
            tabs.odd.bg = mkForce (opacityColor bg);
            completion.even.bg = mkForce (opacityColor bg);
            completion.odd.bg = mkForce (opacityColor bg);
          };
      };

      extraConfig = /* py */ ''
        config.set("tabs.padding", {"bottom": 2, "left": 5, "right": 5, "top": 2})
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
