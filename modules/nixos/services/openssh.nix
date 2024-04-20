{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.services.openssh;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.services.openssh = {
    enable = mkEnableOption "openssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    environment.persistence.main = mkIf imper.enable {
      files = [
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };
}
