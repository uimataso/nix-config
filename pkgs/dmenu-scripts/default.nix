{ pkgs }:
let
  inherit (pkgs) callPackage;
in
{
  dmenu-scripts = {
    power-menu = callPackage ./power-menu.nix { };
    app-launcher = callPackage ./app-launcher.nix { };
  };
}
