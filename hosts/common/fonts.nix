{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    material-symbols
    # awesome-terminal-fonts
  ];
}
