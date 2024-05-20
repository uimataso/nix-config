{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.uimaConfig.theme;
in
{
  options.uimaConfig.theme = {
    enable = mkEnableOption "theme";

    wallpaper = mkOption {
      type = types.path;
      default = ./wallpaper.png;
      description = "Wallpaper image path.";
    };

    scheme = mkOption {
      type = types.path;
      default = ./base16-uicolor.yaml;
      description = "Base16 color scheme to use.";
    };
  };

  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  config = mkIf cfg.enable {
    stylix = {
      image = cfg.wallpaper;
      polarity = "dark";
      # base16Scheme = "${cfg.scheme}";
      base16Scheme = {
        base00 = "161616";
        base01 = "303030";
        base02 = "454545";
        base03 = "808080";
        base04 = "9b9b9b";
        base05 = "bcbcbc";
        base06 = "dddddd";
        base07 = "f5f5f5";
        base08 = "c68586";
        base09 = "edb96e";
        base0A = "d5be95";
        base0B = "86a586";
        base0C = "8caeaf";
        base0D = "83a0af";
        base0E = "d8afad";
        base0F = "b08b76";
      };

      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        monospace = {
          package = (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; });
          name = "MesloLGS Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}

# 0 "#161616"
# 1 "#1e1e1e"
# 2 "#272727"
# 3 "#373737"
# 4 "#585858"
# 5 "#808080"
# 6 "#9b9b9b"
# 7 "#bcbcbc"
# 8 "#c68586"
# 9 "#edb96e"
# A "#d5be95"
# B "#86a586"
# C "#8caeaf"
# D "#83a0af"
# E "#d8afad"
# F "#b08b76"

# 0 "#161616"
# 1 "#303030"
# 2 "#454545"
# 3 "#808080"
# 4 "#9b9b9b"
# 5 "#bcbcbc"
# 6 "#dddddd"
# 7 "#f5f5f5"

# 8 "#c68586"
# 9 "#edb96e"
# A "#d5be95"
# B "#86a586"
# C "#8caeaf"
# D "#83a0af"
# E "#d8afad"
# F "#b08b76"
