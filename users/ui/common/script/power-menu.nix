{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "power-menu";

  text = ''
    # TODO:
    dmenu="''${DMENU:-dmenu -i}"

    # lock;       slock
    list="$(cat <<EOF
    shut down;  poweroff
    reboot;     reboot
    log out;    loginctl terminate-session ''${XDG_SESSION_ID-}
    EOF
    )"

    selected=$(printf '%s' "$list" | cut -d';' -f1 | $dmenu -p "POWER")

    [ -n "$selected" ] && eval "$(echo "$list" | grep "^$selected;" | sed 's/.*;\s\+//')"
  '';
}
