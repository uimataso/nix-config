{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "fmenu";
  runtimeInputs = with pkgs; [
    xdotool
  ];

  text = ''
    name="$(basename "$0")"
    # default_fzf_opt='--height=100% --layout=reverse --color=gutter:-1,pointer:5 --no-separator --info=inline --ansi --bind=enter:replace-query+print-query,alt-enter:print-query,tab:replace-query'
    default_fzf_opt='--height=100% --layout=reverse --no-separator --info=inline --ansi --bind=enter:replace-query+print-query,alt-enter:print-query,tab:replace-query'
    prompt='> '
    line='25'
    column='50'
    fzf_opt='''
    fontsize='16'

    if [ $(pgrep -c "$name") -gt 1 ]; then
      echo 'Other fmenu is running!' >&2
      exit 1
    fi

    # parse options
    TEMP=$(getopt -o 'p:l:c:f:z:' -n "$0" -- "$@")
    # shellcheck disable=SC2181
    [ $? -ne 0 ] && echo 'Failed to parsing options!' >&2 && exit 1
    eval set -- "$TEMP"
    unset TEMP

    while :; do
      case "$1" in
        '-p') prompt="$2";   shift 2 ;;
        '-l') line="$2";     shift 2 ;;
        '-c') column="$2";   shift 2 ;;
        '-f') fzf_opt="$2";  shift 2 ;;
        '-z') fontsize="$2"; shift 2 ;;
        '--') break ;;
        *)    echo 'Internal error!' >&2; exit 1 ;;
      esac
    done

    case $TERMINAL in
      st) term_cmd="st -t $name -g ''${column}x''${line} -z $fontsize -c float" ;;
      foot) term_cmd="foot -T $name -W ''${column}x''${line}" ;;
      alacritty) term_cmd="alacritty -t $name -o window.dimensions.columns=''${column} -o window.dimensions.lines=''${line} -o font.size=''${fontsize} -e" ;;
    esac

    # remember the window that actived
    if [ -n "''${WAYLAND_DISPLAY:+x}" ]; then
      # TODO: wayland support
      true
    elif [ -n "''${DISPLAY:+x}" ]; then
      actived_window="$(xdotool getactivewindow || true)"
    fi

    # spawn the fzf window
    $term_cmd sh -c "fzf $default_fzf_opt --prompt \"$prompt \" $fzf_opt </proc/$$/fd/0 >/proc/$$/fd/1"

    # restore focus to actived window
    if [ -n "''${WAYLAND_DISPLAY:+x}" ]; then
      true
    elif [ -n "''${DISPLAY:+x}" ] && [ -n "$actived_window" ]; then
      xdotool windowactivate "$actived_window"
    fi
  '';
}
