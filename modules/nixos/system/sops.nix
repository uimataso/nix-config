{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.sops;

  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
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
      age = {
        sshKeyPaths = map getKeyPath keys;
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
    };
  };
}
