{
  writeShellApplication,
  pkgs,
  ...
}:
writeShellApplication {
  name = "tmux-toggle-popup";
  runtimeInputs = with pkgs; [
    tmux
  ];

  text = ''
    if [ -z "''${TMUX+x}" ]; then
      echo 'not in the tmux' >&2
      exit 1
    fi

    w=95
    h=90
    name='default'
    cmd="$SHELL"

    if TEMP=$(getopt -o 'w:h:n:' -l 'width:height:name:' -n "$0" -- "$@"); then
      eval set -- "$TEMP"
      unset TEMP
    else
      echo "Failed to parse options" >&2
      exit 1
    fi

    while true; do
        case "$1" in
            '-w'|'--width')   w="$2";     shift 2 ;;
            '-h'|'--height')  h="$2";     shift 2 ;;
            '-n'|'--name')    name="$2";  shift 2 ;;
            '--')
              shift
              [ -n "$*" ] && cmd="$*"
              break ;;
            *) echo "Internal error!" >&2; exit 1 ;;
        esac
    done

    current_session="$(tmux display-message -p -F'#{client_session}' 2>/dev/null)"

    if echo "$current_session" | grep -q '_popup$'; then
      current_window_name="$(tmux display-message -p -F'#{window_name}' 2>/dev/null)"

      if [ "$current_window_name" = "$name" ]; then
        tmux detach-client
      else
        # shellcheck disable=SC2086
        tmux new-window -S -n "$name" -c '#{pane_current_path}' $cmd
      fi
    else
      popup_session="''${current_session}_popup"

      tmux display-popup -d '#{pane_current_path}' -xC -yC -w"$w"% -h"$h"% -E "
        if tmux has-session -t $popup_session 2>/dev/null; then
          tmux attach-session -t $popup_session \; new-window -S -n $name $cmd
        else
          tmux new-session -s $popup_session -n $name $cmd
        fi
      "
    fi
  '';
}
