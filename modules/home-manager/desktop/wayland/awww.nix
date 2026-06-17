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
    ;
  cfg = config.uimaConfig.desktop.wayland.awww;
in
{
  options.uimaConfig.desktop.wayland.awww = {
    enable = mkEnableOption "awww";
    package = lib.mkPackageOption pkgs "awww" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.awww = {
      Unit = {
        Description = "Awww Wayland wallpaper manager";
        Documentation = "https://github.com/LGFae/awww";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/awww-daemon";
        ExecStartPost = "${cfg.package}/bin/awww img ${config.stylix.image}";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
