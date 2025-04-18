{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.virt.docker;
in
{
  options.uimaConfig.virt.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ "/var/lib/docker" ];
    };

    environment.systemPackages = with pkgs; [ docker-compose ];

    virtualisation.docker = {
      enable = true;
      # rootless.enable = true;
    };
  };
}
