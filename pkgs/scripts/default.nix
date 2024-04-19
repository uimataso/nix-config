{ pkgs }:

with pkgs;

{
  build = callPackage ./build.nix { };

  fmenu = callPackage ./fmenu.nix { };
  fff = callPackage ./fff.nix { };

  extract = callPackage ./extract.nix { };
  vl = callPackage ./vl.nix { };
  bright = callPackage ./bright.nix { };

  swallower = callPackage ./swallower.nix { };
  screenshot = callPackage ./screenshot.nix { };

  open = callPackage ./open.nix { };
  power-menu = callPackage ./power-menu.nix { };
  app-launcher = callPackage ./app-launcher.nix { };
}
