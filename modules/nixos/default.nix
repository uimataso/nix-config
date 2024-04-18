{ inputs, outputs, pkgs, ... }:

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

  environment.systemPackages = with pkgs; [
    git  # Since all nix command need git
  ];

  nix = {
    channel.enable = false;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };
}
