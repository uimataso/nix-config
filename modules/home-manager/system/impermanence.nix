{
  config,
  lib,
  pkgs,
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

  # impermanenceModule = inputs.impermanence.nixosModules.impermanence;
  # impermanenceEval = impermanenceModule { inherit config lib pkgs; };
  # impermanenceUserType =
  #   impermanenceEval.options.environment.persistence.main.users.type.getSubOptions
  #     [
  #       "<name>"
  #     ];
in
{
  options.uimaConfig.system.impermanence = {
    enable = mkEnableOption "impermanence";

    files = mkOption {
      type = types.listOf types.str;
      # type = impermanenceUserType.files.type;
      default = [ ];
    };

    directories = mkOption {
      type = types.listOf types.str;
      # type = impermanenceUserType.directories.type;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
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
