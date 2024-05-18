{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.nh;

  flakeDir = "$HOME/nix";
  flakeDirNu = "($env.HOME | path join \"nix\")";
in
{
  options.uimaConfig.sh-util.nh = {
    enable = mkEnableOption ''
      Yet-another-nix-helper and other nix alias/sceripts that improve QoL.
    '';
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      no = "nh os switch ${flakeDir}";
      nt = "nh os test ${flakeDir}";
      nr = ''nix repl --expr "builtins.getFlake \"${flakeDir}\""'';

      # nel = "sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tail";
      #
      # nph = "nix profile history --profile /nix/var/nix/profiles/system";
      # npd = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
      # # remove no changes
      # nphs = ''nph | sed -z 's/Version [^ ]*[0-9]*[^ ]* ([0-9-]*) <- [0-9]*:\n\s*No changes.\n\n//g' '';
      # npds = ''npd | sed -z 's/Version [0-9]* -> [0-9]*:\n\n//g' '';

      it = "${pkgs.scripts.nix-template-tool}/bin/nix-template-tool";
    };

    programs.nushell.shellAliases = {
      no = "nh os switch ${flakeDirNu}";
      nt = "nh os test ${flakeDirNu}";
      nr = ''nix repl --expr "builtins.getFlake \"${flakeDirNu}\""'';

      it = "${pkgs.scripts.nix-template-tool}/bin/nix-template-tool";
    };

    home.packages = [
      pkgs-unstable.nh
    ];
  };
}
