{
  writeShellApplication,
  pkgs,
  initScript,
  ...
}:
writeShellApplication {
  name = "clip";
  runtimeInputs = with pkgs; [
    xclip
    wl-clipboard
  ];

  text = ''
    ${initScript}

    help() {
      echo "Usage: $APP_NAME [options]"
      cat <<EOF

    Copy data from stdin.
    Output clipboard to stdout.

    Options:
      -h, --help                      Display this message.
      -t, --type clipboard|primary    Clipboard type to use. Default: clipboard.
      -m, --mime mime/type            Set the MIME type.
    EOF
    }

    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
      debug "No GUI session detected" >&2
      exit 1
    fi

    type='clipboard'
    mime='''

    if TEMP=$(getopt -o 'ht:m:' -l 'help,type:,mime:' -n "$0" -- "$@"); then
      eval set -- "$TEMP"
      unset TEMP
    else
      debug "Failed to parse options" >&2
      exit 1
    fi

    while true; do
        case "$1" in
            '-h'|'--help')  help; exit ;;
            '-t'|'--type')  type="$2"; shift 2 ;;
            '-m'|'--mime')  mime="$2"; shift 2 ;;
            '--') shift; break ;;
            *) debug "Internal error!" >&2; exit 1 ;;
        esac
    done

    session_type="''${XDG_SESSION_TYPE:-unknown}"

    case "$session_type" in
      # NOTE: x11 is not tested
      'x11')
        opts="-selection $type"
        [ -n "$mime" ] && opts="$opts -target $mime"

        if [ ! -t 0 ]; then
          # shellcheck disable=SC2086
          cat | xclip -in $opts
        fi

        if [ -t 0 ] || [ ! -t 1 ]; then
          # shellcheck disable=SC2086
          xclip -out $opts
        fi
      ;;

      'wayland')
        opts='''

        case "$type" in
          'clipboard') ;;
          'primary') opts="$opts --primary" ;;
          *)
            debug "Not supported clipboard type '$type'" >&2
            exit 1
          ;;
        esac

        [ -n "$mime" ] && opts="$opts --type $mime"

        if [ ! -t 0 ]; then
          # shellcheck disable=SC2086
          cat | wl-copy $opts
        fi

        if [ -t 0 ] || [ ! -t 1 ]; then
          # shellcheck disable=SC2086
          wl-paste $opts
        fi
      ;;

      *)
        debug "Not supported session type '$XDG_SESSION_TYPE'" >&2
        exit 1
      ;;
    esac
  '';
}
