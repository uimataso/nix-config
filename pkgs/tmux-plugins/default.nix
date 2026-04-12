{ pkgs }:
let
  callPackage = pkgs.callPackage;
in
{
  tmux-nvim = callPackage ./tmux-nvim.nix { };
  tmux-smooth-scroll = callPackage ./tmux-smooth-scroll.nix { };
}
