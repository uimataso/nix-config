{ pkgs }:
let
  inherit (pkgs) callPackage;
in
{
  scripts = {
    # Nix utils
    nix-template-tool = callPackage ./nix-template-tool.nix { };

    # Utils
    fff = callPackage ./fff.nix { };
    ux = callPackage ./ux.nix { };
    pdf-decrypt = callPackage ./pdf-decrypt.nix { };
    mkbigfile = callPackage ./mkbigfile.nix { };
    open = callPackage ./open.nix { };
    preview = callPackage ./preview.nix { };

    # System
    vl = callPackage ./vl.nix { };
    bright = callPackage ./bright.nix { };
    clip = callPackage ./clip.nix { };

    # Desktop
    fmenu = callPackage ./fmenu.nix { };
    power-menu = callPackage ./power-menu.nix { };
    app-launcher = callPackage ./app-launcher.nix { };
    screenshot = callPackage ./screenshot.nix { };
  };
}
