{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.desktop.wayland.wlrRandr;

  setupMonitorWaylandPkg = pkgs.writeShellApplication {
    name = "setup-monitor-for-wayland";
    runtimeInputs = with pkgs; [
      wlr-randr
    ];
    text =
      let
        toWlrRandr =
          m:
          let
            output = "--output ${m.name}";
            mode = "--mode ${builtins.toString m.width}x${builtins.toString m.height}@${builtins.toString m.refreshRate}Hz";
            scale = "--scale ${builtins.toString m.scale}";
          in
          "wlr-randr ${output} ${mode} ${scale}";
      in
      builtins.concatStringsSep "\n" (builtins.map toWlrRandr config.uimaConfig.desktop.monitors);
  };
  setupMonitorWayland = "${setupMonitorWaylandPkg}/bin/setup-monitor-for-wayland";
in
{
  options.uimaConfig.desktop.wayland.wlrRandr = {
    enable = mkEnableOption "Setup monitor for Wayland with wlr-randr";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wlr-randr
    ];

    systemd.user.services.wayland-monitor = {
      Unit = {
        Description = "Setup monitor for Wayland";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = setupMonitorWayland;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
