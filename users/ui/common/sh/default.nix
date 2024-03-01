{ config, pkgs, ... }:

# TODO:
# man pager
# entr
# prompt when nix-shell

{
  imports = [
    ./util/fzf.nix
    ./util/lsd.nix
    ./util/tealdeer.nix
  ];

  home.packages = with pkgs; [
    fd
    ripgrep
    htop
    bat
    rsync
  ];

  home.shellAliases = {
    nn = "doas build n";
    nh = "build h";

    c = "cd";
    "c." = "cd ..";
    c- = "cd -";
    c_ = "cd $_";

    e = "$EDITOR";
    "e." = "$EDITOR .";

    l = "ls --color";
    ls = "ls -A --color";
    ll = "ls -Al --color";

    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -iv";
    md = "mkdir -pv";

    df = "df -h";
    du = "du -h";
    free = "free -h";
    ip = "ip -c";
    grep = "grep --color=auto";

    rc = "rsync -vhP";
    fclist = "fc-list : family";

    ipinfo = "curl ipinfo.ip";
    unitest = "curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt";
  };
}
