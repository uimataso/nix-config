{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "fetch-title";
  runtimeInputs = with pkgs; [
    curl
  ];

  text = ''
    help() {
      echo 'Usage: fetch-title [-m|--markdown] <url>'
      cat <<EOF

    Options:
      -h, --help            Display this message.
      -m, --markdown        Output as markdown link, e.g. [<title>](<url>).
    EOF
    }

    if TEMP=$(getopt -o 'hm' -l 'help,markdown' -n "$0" -- "$@"); then
      eval set -- "$TEMP"
      unset TEMP
    else
      echo "Failed to parse options" >&2
      exit 1
    fi

    while true; do
        case "$1" in
            '-h'|'--help')      help; exit ;;
            '-m'|'--markdown')  markdown='true'; shift ;;
            '--')
              shift
              if [ $# -ne 1 ] || [ -z "$1" ]; then
                help | head -n 1 >&2
                exit 1
              fi
              url="$1"
              break ;;
            *) echo "Internal error!" >&2; exit 1 ;;
        esac
    done

    title="$(curl -sL "$url" | sed -n 's/.*<title[^<]*>\(.*\)<\/title>.*/\1/p')"

    if ! [ -n "''${markdown:+x}" ]; then
      printf '%s' "$title"
    else
      printf '%s' "[$title]($url)"
    fi

    # print newline if stdout is not pipe
    [ -t 1 ] && printf '\n'
  '';
}
