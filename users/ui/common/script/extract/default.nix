{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unzip
  ];

  home.file.".local/bin/extract".source = ./extract;
}
