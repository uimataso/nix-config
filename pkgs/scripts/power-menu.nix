{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "power-menu";

  text = ''
    dmenu="''${DMENU:-dmenu -i}"

    declare -A actions
    actions=( #
      # ["Lock"]="slock"
      ["Shut Down"]="poweroff"
      ["Reboot"]="reboot"
      ["Logout"]="loginctl terminate-session ''${XDG_SESSION_ID-}"
    )

    selected="$(printf '%s\n' "''${!actions[@]}" | $dmenu)"

    if [ -z "$selected" ]; then
      exit
    fi

    eval "''${actions["$selected"]}"
  '';
}
