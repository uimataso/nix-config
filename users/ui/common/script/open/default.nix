{ pkgs, ... }:

{
  home.packages = with pkgs; [
    file
  ];

  home.file.".local/bin/open".source = ./open;

  home.shellAliases = {
    o = "open";
    os = "open -s";
  };
}
