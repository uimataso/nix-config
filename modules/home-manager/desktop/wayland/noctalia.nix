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
    ;
  cfg = config.uimaConfig.desktop.wayland.noctalia;
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
    programs.noctalia-shell = {
      enable = true;

      settings = {
        wallpaper = {
          directory = "/share/nix/modules/nixos/theme/wallpapers/";
        };

        bar = {
          density = "compact";
          position = "bottom";
        };
      };
    };
  };
}
