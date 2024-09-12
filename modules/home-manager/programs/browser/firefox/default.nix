{
  config,
  lib,
  inputs,
  ...
}:

# NOTE: Wish list for firefox
# - [-] plugin settings
#   - For uBlock settings, look [here](https://github.com/Kreyren/nixos-config/blob/bd4765eb802a0371de7291980ce999ccff59d619/nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix#L116-L148)
#   - Vimium is unknow
# - [ ] Bookmark (local or here)
# - [ ] Containers (use or not)
# - [-] Disable firefox view (top left on toolbar) (can removed manually)
# - [ ] remove items when start search
# - [ ] precise persistence files

with lib;
let
  cfg = config.uimaConfig.programs.browser.firefox;
in
{
  options.uimaConfig.programs.browser.firefox = {
    enable = mkEnableOption "Firefox";

    defaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = "Use firefox as default browser";
    };
  };

  imports = [
    ./profile_uima.nix
    inputs.arkenfox.hmModules.default
  ];

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

    home.sessionVariables = mkIf cfg.defaultBrowser { BROWSER = "firefox"; };

    programs.firefox = {
      enable = true;
      arkenfox = {
        enable = true;
        version = "126.0";
      };

      # TODO: play with this more, differences with user.js settings?
      policies = {
        Cookies = {
          Behavior = "reject";
          Allow = [
            # Mysite
            "https://uima.duckdns.org"
            "https://uimataso.com"

            # Mail
            "https://proton.me"
            "https://simplelogin.io"

            # Google
            "https://accounts.google.com"
            "https://www.google.com"
            "https://www.youtube.com"

            # Self hosted
            "https://tailscale.com"
            "https://porkbun.com"

            # Dev
            "https://github.com"
            "https://mynixos.com"

            # Other
            "https://chatgpt.com"
            "https://leetcode.com"
            "https://monkeytype.com"
            "https://www.reddit.com"
            "https://www.printables.com"
          ];
        };
      };
    };
  };
}
