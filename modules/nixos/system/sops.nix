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
      defaultSopsFile = ../../../secrets.yaml;

      age = {
        # Default `sshKeyPaths` is auto generated from `services.openssh.hostKeys` with type `ed25519`
        # see: https://github.com/Mic92/sops-nix/blob/09f1bc8ba3277c0f052f7887ec92721501541938/modules/sops/default.nix#L266
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };

      # secrets.hello = {
      #   owner = "ui";
      # };
    };

    # environment.interactiveShellInit = ''
    #   cat ${config.sops.secrets.hello.path}
    # '';

    environment.systemPackages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
  };
}
