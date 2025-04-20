# TODO: secrets
{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.system.openssh;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.system.openssh = {
    enable = mkEnableOption "openssh";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };

      # Auto generate host keys
      hostKeys = mkForce [
        {
          path = "${lib.optionalString imper.enable imper.persist_dir}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
