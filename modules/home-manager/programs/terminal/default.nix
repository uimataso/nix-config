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
  cfg = config.uimaConfig.programs.terminal;
in
{
  imports = [
    ./alacritty.nix
    ./foot.nix
    ./kitty.nix
    ./st.nix
  ];

  options.uimaConfig.programs.terminal = {
    enable = mkEnableOption "Terminal";

    executable = mkOption {
      type = types.str;
      example = "foot";
      description = "Executable path";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      TERMINAL = cfg.executable;
    };
  };
}
