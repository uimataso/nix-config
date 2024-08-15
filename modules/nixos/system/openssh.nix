{
  config,
  lib,
  ...
}:
with lib;
# TODO: secrets
  let
    cfg = config.uimaConfig.system.openssh;

    imper = config.uimaConfig.system.impermanence;
  in {
    options.uimaConfig.system.openssh = {
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

        hostKeys = mkForce [
          {
            path = "${lib.optionalString imper.enable imper.persist_dir}/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };

      environment.persistence.main = mkIf imper.enable {
        files = [
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };
    };
  }
