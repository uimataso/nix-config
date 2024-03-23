{ config, pkgs, ... }:

{
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
  };
}
