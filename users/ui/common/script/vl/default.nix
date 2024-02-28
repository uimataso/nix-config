{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pulseaudio # for pactl
  ];

  home.file.".local/bin/vl".source = ./vl;
}
