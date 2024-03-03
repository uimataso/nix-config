{ pkgs, lib, ... }:

{
  home.shellAliases = {
    l = lib.mkForce "lsd --group-directories-first";
    ls = lib.mkForce "lsd -A --group-directories-first";
    ll = lib.mkForce "lsd -Al --group-directories-first";
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

    colors = {
      user = "green";
      group = "dark_green";
      permission = {
        read = "dark_green";
        write = "dark_yellow";
        exec = "dark_red";
        exec-sticky = 5;
        no-access = 245;
        octal = 6;
        acl = "dark_cyan";
        context = "cyan";
      };
      date = {
        hour-old = "cyan";
        day-old = "cyan";
        older = "cyan";
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
}
