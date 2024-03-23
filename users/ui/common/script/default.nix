{ config, pkgs, lib, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];
  imports = [
    ./fff
  ];

  home.packages = with pkgs; [
    (callPackage ./swallower.nix { })
    (callPackage ./power-menu.nix { })
    (callPackage ./screenshot.nix { })
    (callPackage ./build.nix { })
    (callPackage ./app-launcher.nix { })
    (callPackage ./extract.nix { })
    (callPackage ./vl.nix { })
    (callPackage ./bright.nix { })
    (callPackage ./open.nix { })
    (callPackage ./fmenu.nix { })
  ];
}

# TODO:
# echo "$XDG_BOOKMARK_DIR/bookmark" | entr -np sync-bookmark &
# ibus
# clip
#
# pdf-decrypt
# power-menu
