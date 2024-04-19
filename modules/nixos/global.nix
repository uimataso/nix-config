{ inputs, outputs, pkgs, ... }:

let
  cfg = config.myConfig.global;
in
{
  options.myConfig.global = {
    enable = mkEnableOption "Global settings";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
    };

    environment.systemPackages = with pkgs; [
      git  # Since all nix command need git
    ];

    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
      };
    };
  };
}
