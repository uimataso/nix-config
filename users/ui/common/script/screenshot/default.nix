{ pkgs, ... }:

{
  home.packages = with pkgs; [
    scrot
  ];

  home.file.".local/bin/screenshot".source = ./screenshot;
}
