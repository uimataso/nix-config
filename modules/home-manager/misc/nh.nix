{ config, lib, pkgs-unstable, ... }:

with lib;

let
  cfg = config.myConfig.misc.nh;
in
{
  options.myConfig.misc.nh = {
    enable = mkEnableOption "yet-another-nix-helper";
  };

  config = mkIf cfg.enable {
    # Since nh need `sudo` :(
    home.shellAliases = {
      nn = "doas nixos-rebuild switch --flake \"$HOME/nix#$(hostname)\"";
    };

    home.packages = [
      pkgs-unstable.nh
    ];
  };
}
