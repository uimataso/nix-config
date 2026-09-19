{ writeShellApplication, ... }:
writeShellApplication {
  name = "mkbigfile";

  text = ''
    app_name=''${0##*/}

    help() {
      echo "Usage: $app_name [OPTION] FILENAME"
      cat <<'EOF'
    Make a random big file.

      -h, --help            Show this help.
      -s, --size            Specify the file size to make. Default: 1G
      -b, --bs              Write up to this much bytes at a time. Default: 4k

    P.S. This just a dd wrapper
    EOF
    }

    # Default options
    size='1G'
    bs='4k'

    # Parse options
    if TEMP=$(getopt -o 'hs:b:' -l 'help,size:,bs:' -n "$0" -- "$@"); then
      eval set -- "$TEMP"
      unset TEMP
    else
      echo "$app_name: Failed to parse options"
      exit 1
    fi

    while true; do
        case "$1" in
            '-h'|'--help') help; exit ;;
            '-s'|'--size') size="$2"; shift 2 ;;
            '-b'|'--bs')   bs="$2";   shift 2 ;;
            '--')
              if [ $# -ne 2 ]; then
                help | head -n 1 >&2
                exit 1
              fi
              filename="$2"; break ;;
            *) printf 'Internal error!\n' >&2; exit 1 ;;
        esac
    done

    # Do actual stuff
    dd if=/dev/random of="$filename" bs="$bs" iflag=fullblock,count_bytes status=progress count="$size"
  '';
}
