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
    ;
  cfg = config.uimaConfig.theme;
in
{
  options.uimaConfig.theme = {
    enable = mkEnableOption "Theme";
  };

  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = mkIf cfg.enable {
    # TODO: try to move `~/.icons` and `~/.themes` to xdg config
    # TODO: theme module for home-manager?

    stylix = {
      enable = true;

      image = ./wallpapers/looking-for.png;
      base16Scheme = ./gruvbox-dark-moded.yaml;
      polarity = "dark";

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
