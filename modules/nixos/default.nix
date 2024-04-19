{ inputs, outputs, pkgs, ... }:

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
