{
  config,
  lib,
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

    files = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [ ];
    };

    directories = mkOption {
      type = types.listOf (types.either types.str types.attrs);
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
