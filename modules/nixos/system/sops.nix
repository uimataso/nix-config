{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.sops;
in
{
  options.uimaConfig.system.sops = {
    enable = mkEnableOption "sops";
  };

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = mkIf cfg.enable {
    sops = {
    };
  };
}
