{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.desktop.xserver;
in {
  options.myConfig.desktop.xserver = {
    enable = mkEnableOption "Xserver";
  };

  imports = [
    ./dwm.nix
    ./sddm.nix
  ];

  config = mkIf cfg.enable {
    services.xserver.enable = true;
  };
}
