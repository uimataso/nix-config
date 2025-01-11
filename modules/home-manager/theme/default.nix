{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.theme;

  # See: https://github.com/tinted-theming/schemes
  pre-configured = name: "${pkgs.base16-schemes}/share/themes/${name}.yaml";
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
      # base16Scheme = cfg.scheme;
      # base16Scheme = pre-configured "gruvbox-material-dark-hard";
      base16Scheme = ./gruvbox-dark-moded.yaml;

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
        monospace.name = "MesloLGM Nerd Font";

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
        popups = 0.9;
        terminal = 0.9;
      };
    };
  };
}
