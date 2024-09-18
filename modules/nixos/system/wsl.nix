{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.system.wsl;
in
{
  options.uimaConfig.system.wsl = {
    enable = mkEnableOption "WSL";

    docker.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Docker integration";
    };

    defaultUser = mkOption {
      type = types.str;
      default = "uima";
      description = "Default user";
    };
  };

  imports = [ inputs.nixos-wsl.nixosModules.default ];

  config = mkIf cfg.enable (mkMerge [
    {
      wsl = {
        enable = true;
        defaultUser = cfg.defaultUser;
      };
    }

    # [See this](https://github.com/nix-community/NixOS-WSL/issues/235#issuecomment-1937424376)
    (mkIf cfg.docker.enable {
      wsl = {
        # Enable integration with Docker Desktop (needs to be installed)
        docker-desktop.enable = false;

        # Binaries for Docker Desktop wsl-distro-proxy
        extraBin = with pkgs; [
          { src = "${coreutils}/bin/mkdir"; }
          { src = "${coreutils}/bin/cat"; }
          { src = "${coreutils}/bin/whoami"; }
          { src = "${coreutils}/bin/ls"; }
          { src = "${busybox}/bin/addgroup"; }
          { src = "${su}/bin/groupadd"; }
          { src = "${su}/bin/usermod"; }
        ];
      };

      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
      };

      ## patch the script
      systemd.services.docker-desktop-proxy.script =
        let
          automountRoot = config.wsl.wslConf.automount.root;
        in
        lib.mkForce ''
          ${automountRoot}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${automountRoot}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"
        '';
    })
  ]);
}
