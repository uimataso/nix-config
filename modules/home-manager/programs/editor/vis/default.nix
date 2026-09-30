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
  cfg = config.uimaConfig.programs.editor.vis;
  flakeDir = config.uimaConfig.global.flakeDir;
  visLn =
    path:
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home-manager/programs/editor/vis/${path}";
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

    xdg.configFile = {
      "vis/visrc.lua" = {
        source = visLn "visrc.lua";
      };
      "vis/themes" = {
        source = visLn "/themes";
      };
    }
    // (
      let
        plugins = {
          vis-commentary = pkgs.fetchFromGitHub {
            owner = "Nomarian";
            repo = "vis-commentary";
            rev = "0e06ed8";
            hash = "sha256-ZsbCC4O/UOpfYm2mh4VqJXIUDGwfvFMJXl9sgENWNok=";
          };
          vis-colorizer = pkgs.fetchFromGitHub {
            owner = "thimc";
            repo = "vis-colorizer";
            rev = "0d67d0f";
            hash = "sha256-J8B1jbwlI8ypai54URdd7yg3b7eYH/1ZCwpwGkpMsQ0=";
          };
          vis-surround = pkgs.fetchgit {
            url = "https://repo.or.cz/vis-surround.git";
            rev = "49674c957d9af22f4fbbe118d388bd3c81372a04";
            hash = "sha256-ItNa1Uyr4x0KZi5By603klbaybHOWWMUWSMcMoNC084=";
          };
        };
      in
      lib.mapAttrs' (
        name: src:
        lib.nameValuePair "vis/plugins/${name}" {
          source = src;
        }
      ) plugins
    );

  };
}
