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
  cfg = config.uimaConfig.programs.editor;
in
{
  imports = [
    ./neovim
    ./vscode
  ];

  options.uimaConfig.programs.editor = {
    enable = mkEnableOption "Editor";

    executable = mkOption {
      type = types.str;
      example = "\${pkgs.neovim}/bin/nvim";
      description = "Executable path";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = cfg.executable;
    };
  };
}
