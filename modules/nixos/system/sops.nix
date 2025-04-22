{
  self,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.system.sops;

  isEd25519 = k: k.type == "ed25519";
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
  keyPaths = map (k: k.path) keys;
in
{
  options.uimaConfig.system.sops = {
    enable = mkEnableOption "sops";
  };

  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = mkIf cfg.enable {
    sops = {
      age = {
        sshKeyPaths = keyPaths;
      };
    };

    environment.systemPackages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
  };
}
