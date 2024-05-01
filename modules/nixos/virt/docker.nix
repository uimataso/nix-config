{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.virt.docker;
in
{
  options.uimaConfig.virt.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    virtualisation.docker = {
      enable = true;
      rootless.enable = true;
    };
  };
}
