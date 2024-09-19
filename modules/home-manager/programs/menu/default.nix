{ config
, lib
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.uimaConfig.programs.menu;
in
{
  imports = [
    ./fmenu.nix
    ./tofi.nix
  ];

  options.uimaConfig.programs.menu = {
    enable = mkEnableOption "Menu";

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
