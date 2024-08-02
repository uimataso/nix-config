{ config, lib, pkgs, outputs, ... }:

with lib;

let
  cfg = config.uimaConfig.global;
in
{
  options.uimaConfig.global = {
    enable = mkEnableOption "Global settings";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
    };

    environment.systemPackages = with pkgs; [
      git # Since all nix command need git

      sops
      age
      ssh-to-age
    ];

    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
      };
    };

    # Needed by home-manager and other, so I put this here
    programs.dconf.enable = true;

    uimaConfig.system.openssh.enable = true;
  };
}
