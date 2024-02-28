{ config, pkgs, lib, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];
  imports = [
    ./fff
    ./fmenu
    ./open
    ./extract

    ./vl
    ./bright

    ./app-launcher
  ];

  home.packages = with pkgs; [
    (callPackage ./swallower.nix {})
    (callPackage ./power-menu.nix {})
    (callPackage ./screenshot.nix {})
    (callPackage ./build.nix {})
  ];
}

# TODO:
# echo "$XDG_BOOKMARK_DIR/bookmark" | entr -np sync-bookmark &
# ibus
# clip
#
# pdf-decrypt
# power-menu
