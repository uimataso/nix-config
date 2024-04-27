{ config, lib, pkgs-unstable, ... }:

with lib;

let
  cfg = config.uimaConfig.misc.nh;

  flakeDir = "$HOME/nix";
in
{
  options.uimaConfig.misc.nh = {
    enable = mkEnableOption "yet-another-nix-helper";
  };

  config = mkIf cfg.enable {
    # Since nh need `sudo` :(
    home.shellAliases = {
      nr = "nix repl --expr \"builtins.getFlake \\\"${flakeDir}\\\"\"";
      no = "nh os switch ${flakeDir}";
      nt = "nh os test ${flakeDir}";
    };

    home.packages = [
      pkgs-unstable.nh
    ];
  };
}
