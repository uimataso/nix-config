{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.desktop.xserver;
in
{
  options.uimaConfig.desktop.xserver = {
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
