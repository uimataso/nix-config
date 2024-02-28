{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
    chafa
    bat
  ];

  home.file.".local/bin/fff".source = ./fff;
  home.file.".local/bin/preview".source = ./preview;

  home.shellAliases = {
    a = ". fff";
  };
}
