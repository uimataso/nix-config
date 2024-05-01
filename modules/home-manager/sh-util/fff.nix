{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.fff;
in
{
  options.uimaConfig.sh-util.fff = {
    enable = mkEnableOption "fff. Self written script for file browsing.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      scripts.fff
    ];

    home.shellAliases = {
      a = ". fff";
    };
  };
}
