{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.lazygit;
in
{
  options.uimaConfig.programs.dev.lazygit = {
    enable = mkEnableOption "Lazygit";
  };

  config = mkIf cfg.enable {
    uimaConfig.programs.dev.git.enable = true;

    home.shellAliases = {
      lzg = "lazygit";
    };

    home.packages = with pkgs; [ delta ];

    programs.lazygit = {
      enable = true;

      settings = {
        disableStartupPopups = true;
        gui = {
          theme = with config.lib.stylix.colors.withHashtag; {
            inactiveBorderColor = [ base03 ];
          };
          showBottomLine = false;
        };
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          };
        };
      };
    };
  };
}
