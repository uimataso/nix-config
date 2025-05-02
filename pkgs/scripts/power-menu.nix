{ writeShellApplication }:
writeShellApplication {
  name = "power-menu";

  text = ''
    dmenu="''${DMENU:-dmenu -i}"

    selected="$(cat <<EOF | $dmenu
    Lock
    Logout
    Reboot
    Shut Down
    EOF
    )"

    case "$selected" in
      'Lock') loginctl lock-session ;;
      'Logout') loginctl terminate-session ;;
      'Reboot') reboot ;;
      'Shut Down') poweroff ;;
    esac

  '';
}
