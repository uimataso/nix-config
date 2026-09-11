{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.sh-util.yazi;
in
{
  options.uimaConfig.programs.sh-util.yazi = {
    enable = mkEnableOption "yazi";

    asFileChooser = mkOption {
      type = types.bool;
      default = true;
      description = "Use yazi as file chooser";
    };
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;

      shellWrapperName = "f";

      theme =
        let
          square = {
            open = "▐";
            close = "▌";
          };
        in
        {
          indicator = {
            padding = square;
          };
          tabs = {
            sep_inner = square;
            sep_outer = square;
          };
          status = {
            sep_left = square;
            sep_right = square;
          };
        };
    };

    xdg = mkIf cfg.asFileChooser {
      portal = {
        extraPortals = with pkgs; [
          xdg-desktop-portal-termfilechooser
        ];

        config = {
          common = {
            "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
          };
        };
      };

      configFile = {
        "xdg-desktop-portal-termfilechooser/config" = {
          force = true;
          executable = true;
          text = ''
            [filechooser]
            cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
            default_dir=$HOME
            create_help_file=1
            env=TERMCMD='foot --title filechooser'
            env=PATH="$PATH:/run/current-system/sw/bin"
            open_mode=suggested
            save_mode=last
          '';
        };
      };
    };
  };
}
