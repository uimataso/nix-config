{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkForce
    ;
  cfg = config.uimaConfig.desktop.wayland.noctalia;
  flakeDir = config.uimaConfig.global.flakeDir;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.uimaConfig.desktop.wayland.noctalia = {
    enable = mkEnableOption "noctalia";
    package = lib.mkPackageOption pkgs "noctalia-shell" { };
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      files = [ ".local/state/noctalia/.setup-complete" ];
    };

    home.sessionVariables = {
      QS_ICON_THEME = "Papirus-Dark";
    };

    home.packages = with pkgs; [ papirus-icon-theme ];

    home.file.".local/state/noctalia/settings.toml" = mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home-manager/desktop/wayland/noctalia-settings.toml";
    };

    programs.noctalia = {
      enable = true;

      customPalettes = {
        stylix =
          let
            colors = config.lib.stylix.colors.withHashtag;
          in
          {
            dark = {
              mPrimary = colors.base05;
              mOnPrimary = colors.base00;
              mSecondary = colors.base04;
              mOnSecondary = colors.base00;
              mTertiary = colors.base02;
              mOnTertiary = colors.base05;
              mError = colors.base08;
              mOnError = colors.base00;
              mSurface = colors.base00;
              mOnSurface = colors.base05;
              mSurfaceVariant = colors.base01;
              mOnSurfaceVariant = colors.base05;
              mOutline = colors.base02;
              mShadow = colors.base00;
              mHover = colors.base02;
              mOnHover = colors.base05;
              terminal = {
                background = colors.base00;
                foreground = colors.base05;
                cursor = colors.base05;
                cursorText = colors.base00;
                selectionBg = colors.base02;
                selectionFg = colors.base05;
                normal = {
                  black = colors.base00;
                  red = colors.base08;
                  green = colors.base0B;
                  yellow = colors.base0A;
                  blue = colors.base0D;
                  magenta = colors.base0E;
                  cyan = colors.base0C;
                  white = colors.base05;
                };
                bright = {
                  black = colors.base02;
                  red = colors.base08;
                  green = colors.base0B;
                  yellow = colors.base0A;
                  blue = colors.base0D;
                  magenta = colors.base0E;
                  cyan = colors.base0C;
                  white = colors.base07;
                };
              };
            };
          };
      };
    };
  };
}
