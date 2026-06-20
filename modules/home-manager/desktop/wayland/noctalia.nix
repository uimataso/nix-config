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
    # uimaConfig.system.impermanence = {
    #   directories = [ ".config/noctalia/plugins" ];
    # };

    home.sessionVariables = {
      QS_ICON_THEME = "Papirus-Dark";
    };

    home.packages = with pkgs; [ papirus-icon-theme ];

    home.file.".local/state/noctalia/settings.toml" = mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home-manager/desktop/wayland/noctalia-settings.toml";
    };

    programs.noctalia = {
      enable = true;

      customPalettes = {
      };
    };
  };
}
