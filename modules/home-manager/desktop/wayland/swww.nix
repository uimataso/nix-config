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
  cfg = config.uimaConfig.desktop.wayland.swww;
in
{
  options.uimaConfig.desktop.wayland.swww = {
    enable = mkEnableOption "swww";
    package = lib.mkPackageOption pkgs "swww" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.swww = {
      Unit = {
        Description = "Swww Wayland wallpaper manager";
        Documentation = "https://github.com/LGFae/swww";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/swww-daemon";
        ExecStartPost = "${cfg.package}/bin/swww img ${config.stylix.image}";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
