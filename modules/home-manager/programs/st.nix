{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.programs.st;
in
{
  options.myConfig.programs.st = {
    enable = mkEnableOption "st";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ my-st ];
  };
}
