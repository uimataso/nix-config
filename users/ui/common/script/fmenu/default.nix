{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
    xdotool
  ];
  home.file.".local/bin/fmenu".source = ./fmenu;
  home.sessionVariables = { DMENU = "fmenu"; };
}
