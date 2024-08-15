{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.uimaConfig.system.sops;

  isEd25519 = k: k.type == "ed25519";
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
  keyPaths = map (k: k.path) keys;
in {
  options.uimaConfig.system.sops = {
    enable = mkEnableOption "sops";
  };

  imports = [inputs.sops-nix.nixosModules.sops];

  config = mkIf cfg.enable {
    sops = {
      age.sshKeyPaths = keyPaths;

      secrets.hello = {
        sopsFile = ../../../secrets.yaml;
        owner = "uima";
      };
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
