{ pkgs ? import <nixpkgs> { } }:

with pkgs;

{
  sddm-astronaut-theme = libsForQt5.callPackage ./sddm-astronaut-theme { };
  dwmblocks = callPackage ./dwmblocks { };
  scripts = callPackage ./scripts { };
}
