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
in
{
  options.uimaConfig.system.impermanence = {
    enable = mkEnableOption "impermanence";

    # TODO: use the type from `inputs.impermanence.nixosModules.impermanence`
    files = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    directories = mkOption {
      type = types.listOf types.str;
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
