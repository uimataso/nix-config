{ config, lib, pkgs, stdenv, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver.dwm;
in
{
  options.myConfig.desktop.xserver.dwm = {
    enable = mkEnableOption "dwm";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = [
        (self: super: {
          dwm = super.dwm.overrideAttrs (oldattrs: {
            src = ../../../../pkgs/dwm;
          });
        })
      ];
    };

    environment.systemPackages = with pkgs; [
      (callPackage ../../../../pkgs/dwmblocks { })
    ];

    services.xserver = {
      windowManager.dwm.enable = true;
      # displayManager.setupCommands = ''
      #   dwmblocks &
      # '';
    };
  };
}
