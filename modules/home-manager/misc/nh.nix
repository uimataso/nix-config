{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;

let
  cfg = config.uimaConfig.misc.nh;

  flakeDir = "$HOME/nix";

  templateScript = pkgs.writeShellApplication {
    name = "nix-template-script";
    runtimeInputs = with pkgs; [
      jq
    ];

    text = ''
       nix eval -f nix/templates --json | jq .
    '';
  };
in
{
  options.uimaConfig.misc.nh = {
    enable = mkEnableOption ''
      Yet-another-nix-helper and other nix alias/secropt that improve QoL.
    '';
  };

  config = mkIf cfg.enable {
    # Since nh need `sudo` :(
    home.shellAliases = {
      nr = "nix repl --expr \"builtins.getFlake \\\"${flakeDir}\\\"\"";
      no = "nh os switch ${flakeDir}";
      nt = "nh os test ${flakeDir}";
      it = "${templateScript}/bin/nix-template-script";
    };

    home.packages = [
      pkgs-unstable.nh
    ];
  };
}
