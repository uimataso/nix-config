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

      # TODO: fix theme
      colors = {
        user = "dark_green";
        group = "dark_green";
        permission = {
          read = "dark_green";
          write = "dark_yellow";
          exec = "dark_red";
          exec-sticky = 5;
          no-access = 245;
          octal = 6;
          acl = "dark_cyan";
          context = "dard_cyan";
        };
        date = {
          hour-old = "dark_cyan";
          day-old = "dark_cyan";
          older = "dark_cyan";
        };
        size = {
          none = 2;
          small = 2;
          medium = 2;
          large = 2;
        };
        inode = {
          valid = 13;
          invalid = 245;
        };
        links = {
          valid = 13;
          invalid = 245;
        };
        tree-edge = 245;
      };
    };
  };
}
