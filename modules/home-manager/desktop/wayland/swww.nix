{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.wayland.swww;
in
{
  options.uimaConfig.desktop.wayland.swww = {
    enable = mkEnableOption "swww";

    package = mkOption {
      type = types.package;
      default = pkgs.swww;
      defaultText = literalExpression "pkgs.swww";
      description = ''
        Swww package to use. Set to `null` to use the default package.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.swww = {
      Unit = {
        Description = "A Solution to your Wayland Wallpaper Woes.";
        Documentation = "https://github.com/LGFae/swww";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/swww-daemon";
        ExecStartPost = "${cfg.package}/bin/swww img ${config.stylix.image}";
        Restart = "on-failure";
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };

  };
}