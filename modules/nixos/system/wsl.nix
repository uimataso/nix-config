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

    docker.enableOnBoot = mkOption {
      type = types.bool;
      default = true;
      description = "Started Docker on boot";
    };

    docker.package = mkOption {
      type = types.package;
      default = pkgs.docker;
      defaultText = literalExpression "pkgs.docker";
      description = ''
        Docker package to use. Set to `null` to use the default package.
      '';
    };

    defaultUser = mkOption {
      type = types.str;
      default = "uima";
      description = "Default user";
    };
  };

  imports = [ inputs.nixos-wsl.nixosModules.default ];

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = cfg.defaultUser;
      docker-desktop.enable = cfg.docker.enable;
    };

    # Copy from [nixos modules](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/docker.nix)
    systemd.services.docker = mkIf cfg.docker.enable {
      wantedBy = optional cfg.docker.enableOnBoot "multi-user.target";
      after = [ "network.target" "docker.socket" ];
      requires = [ "docker.socket" ];
      environment = config.networking.proxy.envVars;
      serviceConfig = {
        Type = "notify";
        ExecStart = "${cfg.docker.package}/bin/dockerd";
        ExecReload = "${pkgs.procps}/bin/kill -s HUP $MAINPID";
      };
    };

    systemd.sockets.docker = mkIf cfg.docker.enable {
      description = "Docker Socket for the API";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = [ "/run/docker.sock" ];
        SocketMode = "0660";
        SocketUser = "root";
        SocketGroup = "docker";
      };
    };

  };
}
