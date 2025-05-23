{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    mkDefault
    ;
  cfg = config.uimaConfig.sh;

  mkEverythingDefault = attr: lib.attrsets.mapAttrs (name: value: mkDefault value) attr;

  # Core Utils alias
  coreutilsAliases = mkEverythingDefault {
    c = "cd";
    c- = "cd -";
    c_ = "cd $_";
    "c." = "cd ..";
    "c.." = "cd ../..";
    "c..." = "cd ../../..";
    "c...." = "cd ../../../..";
    "c....." = "cd ../../../../..";

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
  imports = [
    ./bash
    ./nushell
  ];

  options.uimaConfig.sh = {
    enable = mkEnableOption "Sh";

    executable = mkOption {
      type = types.str;
      example = "\${pkgs.bashInteractive}/bin/bash";
      description = "Executable path";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      SHELL = cfg.executable;
    };

    # TODO: manage aliases
    home.shellAliases = {
      free = "free -h";
      ip = "ip -c";
      ipa = "ip -c -br a";
      grep = "grep --color=auto";
      dl = "curl -OJL";
      fclist = "fc-list : family";
      unitest = "curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt";
      save = ''history 2 | head -n1 | sed 's/^\s*[0-9]*\s*//' | clip | xargs -I {} notify-send 'Command saved' "{}"'';

      ":w" = "ls";
      ":q" = "clear";
      ":wa" = "clear && ll";
      ":qa" = "clear";
      ":wq" = "clear && ls";
      ":wqa" = "clear && ll";
    };

    programs.bash.shellAliases = coreutilsAliases;

    # Nushell uses its own coreutils
    programs.nushell.shellAliases = mkEverythingDefault config.home.shellAliases;
  };
}
