{ pkgs }:

with pkgs;

{
  nix-template-tool = callPackage ./nix-template-tool.nix { };

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

  # TODO: these script not import to nix yet
  # echo "$XDG_BOOKMARK_DIR/bookmark" | entr -np sync-bookmark &
  # ibus
  # clip
  #
  # pdf-decrypt
  # power-menu
}
