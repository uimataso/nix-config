{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;
  cfg = config.uimaConfig.services.systemdNotify;

  notifyAllScript =
    notifySendArgs:
    # sh
    ''
      for bus in /run/user/*/bus; do
        user_id="$(basename "$(dirname "$bus")")"

        ${pkgs.sudo}/bin/sudo -u "$(id -n -u "$user_id")" \
          DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" \
          ${pkgs.libnotify}/bin/notify-send ${notifySendArgs}
      done
    '';

  notifyScript =
    username: notifySendArgs:
    # sh
    ''
      ${pkgs.sudo}/bin/sudo -u '${username}' \
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u '${username}')/bus" \
        ${pkgs.libnotify}/bin/notify-send ${notifySendArgs}
    '';
in
{
  options.uimaConfig.services.systemdNotify = {
    services = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
                description = "Name of the systemd unit name";
              };

              username = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Who to send the notification. Set to `null` to send to all users";
              };

              onStart = mkOption {
                type = types.nullOr types.str;
                description = "The `notify-send` args used on start";
              };

              onSuccess = mkOption {
                type = types.nullOr types.str;
                description = "The `notify-send` args used on success";
              };

              onFailure = mkOption {
                type = types.nullOr types.str;
                description = "The `notify-send` args used on failure";
              };
            };
          }
        )
      );

      default = { };
      description = "...";
    };
  };

  config = {
    systemd.services = lib.concatMapAttrs (
      name: serviceCfg:
      let
        mkNotify =
          args:
          if serviceCfg.username == null then notifyAllScript args else notifyScript serviceCfg.username args;
      in
      {
        "${name}" = lib.mkMerge [
          { }
          (mkIf (serviceCfg.onStart != null) { preStart = mkNotify serviceCfg.onStart; })
          (mkIf (serviceCfg.onSuccess != null) { onSuccess = [ "${name}-success-notify.service" ]; })
          (mkIf (serviceCfg.onFailure != null) { onFailure = [ "${name}-failure-notify.service" ]; })
        ];

        "${name}-success-notify" = mkIf (serviceCfg.onSuccess != null) {
          enable = config.systemd.services.${name}.enable;
          description = "Success notification for ${name} service";
          script = mkNotify serviceCfg.onSuccess;
        };

        "${name}-failure-notify" = mkIf (serviceCfg.onFailure != null) {
          enable = config.systemd.services.${name}.enable;
          description = "Failure notification for ${name} service";
          script = mkNotify serviceCfg.onFailure;
        };
      }
    ) cfg.services;
  };
}
