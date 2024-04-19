{ config, lib, pkgs, inputs, outputs, ... }:

with lib;

{
  imports = [
    ./global.nix
    ./users
    ./system
    ./boot
    ./networking
    ./desktop
    ./programs
    ./services
    ./virt
  ] ++ [
    inputs.disko.nixosModules.disko
  ];

  myConfig.global.enable = mkDefault true;
}
