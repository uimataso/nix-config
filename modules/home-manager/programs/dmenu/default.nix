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
  cfg = config.uimaConfig.programs.dmenu;
in
{
  imports = [
    ./fmenu.nix
    ./tofi.nix
  ];

  # TODO: make a value that can setting default app-luncher AND dmenu
  options.uimaConfig.programs.dmenu = {
    enable = mkEnableOption "Dmenu";

    executable = mkOption {
      type = types.str;
      example = "fmenu";
      description = "Executable path";
    };

    # appLuncher = mkOption {
    #   type =  types.str;
    # };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      DMENU = cfg.executable;
    };
  };
}
