{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.alias;
in
{
  options.uimaConfig.sh.alias = {
    enable = mkEnableOption "Alias";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
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
  };
}
