{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.uimaConfig.programs.editor.neovim;
  flakeDir = config.uimaConfig.global.flakeDir;
in
{
  options.uimaConfig.programs.editor.vis = {
    enable = mkEnableOption "vis";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.vis
    ];

    home.shellAliases = {
      # set TERM to fix color in tmux
      vis = "TERM=xterm-256color vis";
    };

    xdg.configFile."vis" = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home-manager/programs/editor/vis";
    };
  };
}
