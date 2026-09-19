{
  writeShellApplication,
  pkgs,
  ...
}:
writeShellApplication {
  name = "notify-send-all";

  text = ''
    for bus in /run/user/*/bus; do
      user_id="$(basename "$(dirname "$bus")")"

      /run/wrappers/bin/sudo -u "$(id -n -u "$user_id")" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" \
        ${pkgs.libnotify}/bin/notify-send "$@"
    done
  '';
}
