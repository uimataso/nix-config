{
  writeShellApplication,
  pkgs,
  ...
}:
writeShellApplication {
  name = "tmux-toggle-split";
  runtimeInputs = with pkgs; [
    tmux
  ];

  text = ''
    if [ -z "''${TMUX+x}" ]; then
      echo 'not in the tmux' >&2
      exit 1
    fi

    name='default'
    cmd="$SHELL"

    if TEMP=$(getopt -o 'n:' -l 'name:' -n "$0" -- "$@"); then
      eval set -- "$TEMP"
      unset TEMP
    else
      echo "Failed to parse options" >&2
      exit 1
    fi

    while true; do
        case "$1" in
            '-n'|'--name')    name="$2";  shift 2 ;;
            '--')
              shift
              [ -n "$*" ] && cmd="$*"
              break ;;
            *) echo "Internal error!" >&2; exit 1 ;;
        esac
    done

    mark="@split-$name"
    tmp_window="_$name"

    pane_id="$(tmux show-options -v "$mark" 2>/dev/null || true)"

    if [ -n "$pane_id" ]; then
      if tmux list-panes -a -F '#{pane_id}' | grep -q "^''${pane_id}$"; then
        pane_win="$(tmux display-message -p -t "$pane_id" '#{window_id}')"
        current_win="$(tmux display-message -p '#{window_id}')"

        if [ "$pane_win" = "$current_win" ]; then
          tmux break-pane -s "$pane_id" -n "$tmp_window" -d
        else
          tmux join-pane -h -s "$pane_id"
        fi
      else
        tmux set-option -u "$mark"
        pane_id=""
      fi
    fi

    if [ -z "$pane_id" ]; then
      cwd="$(tmux display-message -p '#{pane_current_path}')"
      new_pane="$(tmux split-window -h -c "$cwd" -P -F '#{pane_id}' "$cmd")"

      tmux set-option "$mark" "$new_pane"
    fi
  '';
}
