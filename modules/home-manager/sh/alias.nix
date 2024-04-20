{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.alias;

  mkEverythingDefault = attr:
    attrsets.mapAttrs (name: value: mkDefault value) attr;
in
{
  options.uimaConfig.sh.alias = {
    enable = mkEnableOption "Alias";
  };

  config = mkIf cfg.enable {
    home.shellAliases = mkEverythingDefault {
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

      dl = "curl -OJL";

      df = "df -h";
      du = "du -h";
      free = "free -h";
      ip = "ip -c";
      ipa = "ip -c -br a";
      grep = "grep --color=auto";
    };
  };
}
