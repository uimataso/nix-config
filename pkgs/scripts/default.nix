{ pkgs }:
let
  inherit (pkgs) callPackage;

  initScript = # sh
    ''
      APP_NAME=''${0##*/}

      debug() {
        echo "$APP_NAME: $*"
      }
    '';
in
{
  inherit initScript;

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
    fetch-title = callPackage ./fetch-title.nix { };

    # System
    vl = callPackage ./vl.nix { };
    clip = callPackage ./clip.nix { };

    # Desktop
    fmenu = callPackage ./fmenu.nix { };
    power-menu = callPackage ./power-menu.nix { };
    app-launcher = callPackage ./app-launcher.nix { };
    screenshot = callPackage ./screenshot.nix { };
  };
}
