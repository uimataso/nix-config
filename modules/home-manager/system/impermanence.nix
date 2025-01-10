{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
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

  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  config = mkIf cfg.enable {
    home.persistence.main = {
      persistentStoragePath = cfg.persist_dir;
      allowOther = true;
      directories = [
        # Otherwise the cache file will be owned by root
        ".cache/nix"
      ];
    };

    home.activation = {
      rmSomeThing =
        lib.hm.dag.entryAfter [ "writeBoundary" ] # sh

          ''
            rm -rf $HOME/.nix-defexpr
            rm -rf $HOME/.nix-profile
          '';
    };
  };
}
