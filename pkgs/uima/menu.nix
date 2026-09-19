{
  writeShellApplication,
  initScript,
  ...
}:
writeShellApplication {
  name = "menu";

  text = ''
    ${initScript}

    help() {
      echo "Usage: $APP_NAME [options]"
      cat <<'EOF'
    Options:
      -h, --help                  Display this message.
      -p, --prompt <text>         Prompt text.
    EOF
    }

    if TEMP=$(getopt -o 'hp:i:' -l 'help,prompt:,type:,mime:' -n "$0" -- "$@"); then
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
  '';
}
