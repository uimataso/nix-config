{ config, lib, pkgs, inputs, outputs, ... }:

with lib;

{
  imports = [
    ./global.nix
    ./system
    ./sh
    ./sh-util
    ./dev
    ./programs
    ./services
    ./desktop
    ./misc
  ];

  myConfig.global.enable = mkDefault true;
  myConfig.misc.theme.enable = mkDefault true;
}
