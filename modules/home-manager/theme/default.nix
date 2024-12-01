{ config
, lib
, pkgs
, inputs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.uimaConfig.theme;
in
{
  options.uimaConfig.theme = {
    enable = mkEnableOption "Theme";

    wallpaper = mkOption {
      type = types.path;
      default = ./default-wallpaper.png;
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
      enable = true;

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

      cursor = {
        size = 14;
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ-AA";
      };

      fonts = {
        serif.package = pkgs.noto-fonts-cjk-serif;
        serif.name = "Noto Serif CJK TC";

        sansSerif.package = pkgs.noto-fonts-cjk-sans;
        sansSerif.name = "Noto Sans CJK TC";

        monospace.package = pkgs.nerd-fonts.meslo-lg;
        monospace.name = "MesloLGS Nerd Font";

        emoji.package = pkgs.noto-fonts-emoji;
        emoji.name = "Noto Color Emoji";

        sizes = {
          applications = 11;
          desktop = 10;
          popups = 10;
          terminal = 11;
        };
      };

      opacity = {
        applications = 0.9;
        desktop = 1.0;
        popups = 1.0;
        terminal = 0.9;
      };
    };
  };
}

# base00 = "#161616";
# base01 = "#303030";
# base02 = "#454545";
# base03 = "#808080";
# base04 = "#9b9b9b";
# base05 = "#bcbcbc";
# base06 = "#dddddd";
# base07 = "#f5f5f5";
# base08 = "#c68586";
# base09 = "#edb96e";
# base0A = "#d5be95";
# base0B = "#86a586";
# base0C = "#8caeaf";
# base0D = "#83a0af";
# base0E = "#d8afad";
# base0F = "#b08b76";
