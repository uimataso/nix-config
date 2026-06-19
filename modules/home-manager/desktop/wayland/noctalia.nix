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
    home.sessionVariables = {
      # QT_QPA_PLATFORMTHEME = "gtk3";
    };

    # nix shell nixpkgs#json-diff -c bash -c "json-diff <(jq -S . ~/.config/noctalia/settings.json) <(noctalia-shell ipc call state all | jq -S .settings)"

    xdg.configFile."noctalia/settings.json" = mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home-manager/desktop/wayland/noctalia-settings.json";
    };

    programs.noctalia-shell = {
      enable = true;
      settings = { };
    };
  };
}
