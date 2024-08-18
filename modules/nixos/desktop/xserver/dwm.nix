{
  config,
  lib,
  pkgs,
  stdenv,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.xserver.dwm;
in
{
  options.uimaConfig.desktop.xserver.dwm = {
    enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dwmblocks ];

    services.xserver = {
      windowManager.dwm = {
        enable = true;
        package = with pkgs; (dwm.overrideAttrs {
          src = fetchFromGitHub {
            owner = "uimataso";
            repo = "dwm";
            rev = "caf45180c0f1a2c21baf9c8445ef8c53b72c68e7";
            sha256 = "sha256-CKo+Z2IQ5gd7zQJmGWPv0WCzpRqLQsTg7TJCrCRNW5k=";
          };
        });
      };

      # displayManager.setupCommands = ''
      #   dwmblocks &
      # '';
    };
  };
}
