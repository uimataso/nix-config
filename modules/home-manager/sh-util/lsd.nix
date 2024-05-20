{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.lsd;
in
{
  options.uimaConfig.sh-util.lsd = {
    enable = mkEnableOption "lsd";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      l = "lsd --group-directories-first";
      ls = "lsd -A --group-directories-first";
      ll = "lsd -Al --group-directories-first";
    };

    programs.lsd = {
      enable = true;

      settings = {
        classic = false;
        blocks = [
          "permission"
          "user"
          "size"
          "date"
          "name"
        ];
        color = {
          when = "auto";
          theme = "custom";
        };
        date = "+%D";
        dereference = false;
        icons = {
          when = "auto";
          theme = "fancy";
          separator = " ";
        };
        indicators = false;
        layout = "grid";
        recursion = {
          enabled = false;
        };
        size = "short";
        permission = "rwx";
        sorting = {
          column = "name";
          reverse = false;
          dir-grouping = "first";
        };
        no-symlink = false;
        total-size = false;
        hyperlink = "never";
        symlink-arrow = "⇒";
        header = false;
      };
    };
  };
}
