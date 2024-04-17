{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.sh-util.fff;
in
{
  options.myConfig.sh-util.fff = {
    enable = mkEnableOption "fff. Self written script for file browsing.";
    # TODO: option for diff ls
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fff
    ];

    home.shellAliases = {
      a = ". fff";
    };
  };
}
