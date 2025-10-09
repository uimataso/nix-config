{
  writeShellApplication,
  pkgs,
}:
writeShellApplication {
  name = "notify-send-all";

  # FIXME: when just `notify-send-all` (not `sudo notify-send-all`):
  # sudo: /nix/store/.../bin/sudo must be owned by uid 0 and have the setuid bit set
  text = ''
    for bus in /run/user/*/bus; do
      user_id="$(basename "$(dirname "$bus")")"

      ${pkgs.sudo}/bin/sudo -u "$(id -n -u "$user_id")" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" \
        ${pkgs.libnotify}/bin/notify-send "$@"
    done
  '';
}
