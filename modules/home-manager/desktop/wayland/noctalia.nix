{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkForce
    ;
  cfg = config.uimaConfig.desktop.wayland.noctalia;
  flakeDir = config.uimaConfig.global.flakeDir;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.uimaConfig.desktop.wayland.noctalia = {
    enable = mkEnableOption "noctalia";
    package = lib.mkPackageOption pkgs "noctalia-shell" { };
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".config/noctalia/plugins" ];
    };

    home.sessionVariables = {
      QS_ICON_THEME = "Papirus-Dark";
    };

    home.packages = with pkgs; [ papirus-icon-theme ];

    xdg.configFile."noctalia/settings.json" = mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home-manager/desktop/wayland/noctalia-settings.json";
    };

    programs.noctalia-shell = {
      enable = true;

      # TODO: fcitx (ime) on bar
      plugins = {
        version = 2;
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          privacy-indicator = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          # TODO: perm, switch account
          tailscale = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
      };
    };
  };
}
