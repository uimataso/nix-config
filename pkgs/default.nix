{ pkgs ? import <nixpkgs> { } }:

with pkgs;

{
  sddm-astronaut-theme = libsForQt5.callPackage ./sddm-astronaut-theme { };

  dwmblocks = callPackage ./dwmblocks { };

  # scripts
  # TODO: import script here or ./script/default.nix
  build = callPackage ./scripts/build.nix { };

  fmenu = callPackage ./scripts/fmenu.nix { };
  fff = callPackage ./scripts/fff.nix { };

  extract = callPackage ./scripts/extract.nix { };
  vl = callPackage ./scripts/vl.nix { };
  bright = callPackage ./scripts/bright.nix { };

  swallower = callPackage ./scripts/swallower.nix { };
  screenshot = callPackage ./scripts/screenshot.nix { };

  open = callPackage ./scripts/open.nix { };
  power-menu = callPackage ./scripts/power-menu.nix { };
  app-launcher = callPackage ./scripts/app-launcher.nix { };
}
