{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.alias;

  mkEverythingDefault = attr:
    attrsets.mapAttrs (name: value: mkDefault value) attr;

  # Core Utils alias
  coreutilsAliases = mkEverythingDefault {
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
  };
in
{
  options.uimaConfig.sh.alias = {
    enable = mkEnableOption "Aliases for coreutils and common commands";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      free = "free -h";
      ip = "ip -c";
      ipa = "ip -c -br a";
      grep = "grep --color=auto";
      dl = "curl -OJL";
    };

    programs.bash.shellAliases = coreutilsAliases;

    # Nushell uses its own coreutils
    programs.nushell.shellAliases = mkEverythingDefault config.home.shellAliases // {
      c = "cd";
      "c." = "cd ..";
      c- = "cd -";
      c_ = "cd $env._";

      e = "exec $env.EDITOR";
      "e." = "exec $env.EDITOR .";

      l = "ls";
      ls = "ls -a";
      ll = "ls -al";

      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -iv";
      md = "mkdir -v";

      df = "df -h";
    };
  };
}
