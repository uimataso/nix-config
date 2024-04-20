{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.system.impermanence = {
    enable = mkEnableOption "impermanence";

    persist_dir = mkOption {
      type = types.str;
      default = "/persist/${config.home.homeDirectory}";
      description = "The directory to store persistent data.";
    };
  };

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  config = mkIf cfg.enable {
    home.persistence.main = {
      persistentStoragePath = cfg.persist_dir;
      allowOther = true;
    };

    home.activation = {
      rmSomeThing = hm.dag.entryAfter ["writeBoundary"] ''
        rm -rf $HOME/.nix-defexpr
        rm -rf $HOME/.nix-profile
      '';
    };
  };
}
