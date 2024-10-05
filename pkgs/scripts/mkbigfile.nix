{ writeShellApplication }:
writeShellApplication {
  name = "mkbigfile";

  text = ''
    usage() {
      cat <<EOF
    Usage: ''${0##*/} [OPTION] FILE
    Make random big file.

      -h, --help            Show this help.
      -s, --size            Specify the size to make. Default: 1G
      -b, --bs              Write how much bytes in one time. Default: 4k

    P.S. This just a dd wrapper
    EOF
      exit
    }

    # Default options
    size='1G'
    bs='4k'

    TEMP=$(getopt -o 'hs:b:' -l 'help,size:,bs:' -n "$0" -- "$@")
    # shellcheck disable=SC2181
    [ $? -ne 0 ] && exit 1
    eval set -- "$TEMP"
    unset TEMP
    while true; do
        case "$1" in
            '-h'|'--help') usage ;;
            '-s'|'--size') size="$2"; shift 2 ;;
            '-b'|'--bs')   bs="$2";   shift 2 ;;
            '--')
              if [ $# -ne 2 ]; then
                usage | head -n 1 >&2
                exit 1
              fi
              filename="$2"; break ;;
            *) printf 'Internal error!\n' >&2; exit 1 ;;
        esac
    done

    dd if=/dev/random of="$filename" bs="$bs" iflag=fullblock,count_bytes status=progress count="$size"
  '';
}
