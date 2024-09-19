{ pkgs }:
let
  inherit (pkgs) callPackage;
in
{
  # Nix utils
  nix-template-tool = callPackage ./nix-template-tool.nix { };

  # Utils
  fff = callPackage ./fff.nix { };
  extract = callPackage ./extract.nix { };
  pdf-decrypt = callPackage ./pdf-decrypt.nix { };

  # System
  vl = callPackage ./vl.nix { };
  bright = callPackage ./bright.nix { };

  # Desktop
  fmenu = callPackage ./fmenu.nix { };
  open = callPackage ./open.nix { };
  power-menu = callPackage ./power-menu.nix { };
  app-launcher = callPackage ./app-launcher.nix { };
  swallower = callPackage ./swallower.nix { };
  screenshot = callPackage ./screenshot.nix { };
}
