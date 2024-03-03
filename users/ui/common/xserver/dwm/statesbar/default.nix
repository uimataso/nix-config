{ config, pkgs, lib, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin/statesbar" ];
  home.file.".local/bin/statesbar".source = ./statusbar;
}
