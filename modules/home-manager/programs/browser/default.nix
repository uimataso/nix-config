{ config
, lib
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.uimaConfig.programs.browser;
in
{
  imports = [
    ./firefox
    ./qutebrowser
  ];

  options.uimaConfig.programs.browser = {
    enable = mkEnableOption "Browser";

    executable = mkOption {
      type = types.str;
      example = "firefox";
      description = "Executable path";
    };

    desktop = mkOption {
      type = types.str;
      example = "firefox.desktop";
      description = "Desktop application name";
    };
  };

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ cfg.desktop ];
      "text/xml" = [ cfg.desktop ];
      "x-scheme-handler/http" = [ cfg.desktop ];
      "x-scheme-handler/https" = [ cfg.desktop ];
    };

    home.sessionVariables = {
      BROWSER = cfg.executable;
    };
  };
}
