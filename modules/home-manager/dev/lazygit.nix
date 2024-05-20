{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.dev.lazygit;

  scheme = config.stylix.base16Scheme;
in
{
  options.uimaConfig.dev.lazygit = {
    enable = mkEnableOption "Lazygit";
  };

  config = mkIf cfg.enable {
    uimaConfig.dev.git.enable = true;

    home.shellAliases = {
      lg = "lazygit";
    };

    home.packages = with pkgs; [
      delta
    ];

    programs.lazygit = {
      enable = true;

      settings = {
        disableStartupPopups = true;
        gui = {
          theme.inactiveBorderColor = [ "#${scheme.base03}" ];
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
