{ config
, lib
, ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.terminal;
in
{
  imports = [
    ./alacritty.nix
    ./foot.nix
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
