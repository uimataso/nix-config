{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;

let
  cfg = config.uimaConfig.misc.nh;

  flakeDir = "$HOME/nix";
in
{
  options.uimaConfig.misc.nh = {
    enable = mkEnableOption ''
      Yet-another-nix-helper and other nix alias/sceripts that improve QoL.
    '';
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      no = "nh os switch ${flakeDir}";
      nt = "nh os test ${flakeDir}";
      nr = "nix repl --expr \"builtins.getFlake \\\"${flakeDir}\\\"\"";
      nph = "nix profile history --profile /nix/var/nix/profiles/system";
      npd = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
      it = "${pkgs.nix-template-tool}/bin/nix-template-tool";
    };

    home.packages = [
      pkgs-unstable.nh
    ];
  };
}
