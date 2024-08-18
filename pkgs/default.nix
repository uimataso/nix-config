{
  pkgs ? import <nixpkgs> { },
}:
with pkgs;
{
  sddm-astronaut-theme = libsForQt5.callPackage ./sddm-astronaut-theme { };
  scripts = callPackage ./scripts { };
  # dwmblocks = callPackage ./dwmblocks { };
}
