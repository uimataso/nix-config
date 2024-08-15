{pkgs}: let
  callPackage = pkgs.callPackage;
in {
  tmux-nvim = callPackage ./tmux-nvim.nix {};
  extrakto = callPackage ./extrakto.nix {};
}
