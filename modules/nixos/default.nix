{ inputs, outputs, ... }:

{
  imports = [
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

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };
}
