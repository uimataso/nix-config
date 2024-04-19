{ config, lib, pkgs, inputs, outputs, ... }:

with lib;

let
  cfg = config.myConfig.global;
in
{
  options.myConfig.global = {
    enable = mkEnableOption "Global settings";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.nur.overlay
    ] ++ builtins.attrValues outputs.overlays;

    home.homeDirectory = mkDefault "/home/${config.home.username}";

    nixpkgs.config.allowUnfree = true;

    nix.package = mkDefault pkgs.nix;

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    news.display = "silent";

    myConfig.misc.theme.enable = mkDefault true;
  };
}
