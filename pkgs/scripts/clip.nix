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
      -q, --quiet                     Don't print to stdout.
      -t, --type clipboard|primary    Clipboard type to use. Default: clipboard.
      -m, --mime mime/type            Set the MIME type.
    EOF
    }

    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
      debug "No GUI session detected" >&2
      exit 1
    fi

    quiet='''
    type='clipboard'
    mime='''

    if TEMP=$(getopt -o 'hqt:m:' -l 'help,quiet,type:,mime:' -n "$0" -- "$@"); then
      eval set -- "$TEMP"
      unset TEMP
    else
      debug "Failed to parse options" >&2
      exit 1
    fi

    while true; do
        case "$1" in
            '-h'|'--help')    help; exit ;;
            '-q'|'--quiet')   quiet='true'; shift ;;
            '-t'|'--type')    type="$2"; shift 2 ;;
            '-m'|'--mime')    mime="$2"; shift 2 ;;
            '--') shift; break ;;
            *) debug "Internal error!" >&2; exit 1 ;;
        esac
    done

    session_type="''${XDG_SESSION_TYPE:-unknown}"

    case "$session_type" in
      'x11'|'wayland') ;;
      *)
        debug "Not supported session type '$XDG_SESSION_TYPE'" >&2
        exit 1
      ;;
    esac

    xclip_opts() {
      opts="-selection $type"
      [ -n "$mime" ] && opts="$opts -target $mime"
      printf '%s' "$opts"
    }

    wl_clipboard_opts() {
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

      printf '%s' "$opts"
    }


    copy() {
      case "$session_type" in
        'x11')
          # shellcheck disable=SC2046
          cat | xclip -in $(xclip_opts)
          ;;
        'wayland')
          # shellcheck disable=SC2046
          cat | wl-copy $(wl_clipboard_opts)
          ;;
      esac
    }

    paste() {
      case "$session_type" in
        'x11')
          # shellcheck disable=SC2046
          xclip -out $(xclip_opts)
          ;;
        'wayland')
          # shellcheck disable=SC2046
          wl-paste -n $(wl_clipboard_opts)
          ;;
      esac
    }

    if [ ! -t 0 ]; then
      # trim newline at the end
      cat | sed -z 's/\n$//' | copy
    fi

    if [ -z "$quiet" ]; then
      paste

      # print a newline if stdout is not pipe
      [ -t 1 ] && printf '\n'
    fi
  '';
}
