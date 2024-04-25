{ config, lib, pkgs-unstable, ... }:

with lib;

let
  cfg = config.uimaConfig.misc.nh;
in
{
  options.uimaConfig.misc.nh = {
    enable = mkEnableOption "yet-another-nix-helper";
  };

  config = mkIf cfg.enable {
    # Since nh need `sudo` :(
    home.shellAliases = {
      nn = "doas nixos-rebuild switch --flake \"$HOME/nix#$(hostname)\"";
      nr = "nix repl --expr \"builtins.getFlake \\\"$HOME/nix\\\"\"";
      no = "nh os switch $HOME/nix";
    };

    home.packages = [
      pkgs-unstable.nh
    ];
  };
}
