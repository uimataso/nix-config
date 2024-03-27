{ config, pkgs, ... }:

# TODO:
# entr

{
  imports = [
    ./git.nix
    ./fzf.nix
    ./tmux.nix
    ./lsd.nix
    ./tealdeer.nix
    ./lazygit.nix
  ];

  home.packages = with pkgs; [
    fd
    ripgrep
    htop
    bat
    rsync
    jq
  ];

  home.shellAliases = {
    rc = "rsync -vhP";
    fclist = "fc-list : family";

    ipinfo = "curl ipinfo.ip";
    unitest = "curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt";
  };
}
