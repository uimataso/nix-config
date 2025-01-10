{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.virt.docker;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.virt.docker = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    environment.persistence.main = mkIf imper.enable { directories = [ "/var/lib/docker" ]; };

    environment.systemPackages = with pkgs; [ docker-compose ];

    virtualisation.docker = {
      enable = true;
      # rootless.enable = true;
    };
  };
}
