{ config, pkgs, lib, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    DMENU = "fmenu";
  };

  home.shellAliases = {
    a = ". fff";
    o = "open";
  };

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
    (callPackage ./fff.nix { })
  ];
}

# TODO:
# echo "$XDG_BOOKMARK_DIR/bookmark" | entr -np sync-bookmark &
# ibus
# clip
#
# pdf-decrypt
# power-menu
