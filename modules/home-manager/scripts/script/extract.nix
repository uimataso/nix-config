{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "extract";
  runtimeInputs = with pkgs; [
    gnutar
    unzip
  ];

  text = ''
    if [ -z "''${1+x}" ]; then
      echo "Usage: ''${0##*/} [FILE]..." >&2
      exit 1
    fi

    for n in "$@"; do
      if [ ! -f "$n" ];then
        echo "''${0##*/}: File '$n' do not exist" >&2
        continue
      fi

      case "''${n%,}" in
        *.tar)        tar xf "$n"     ;;
        *.tar.xz)     tar xf "$n"     ;;
        *.tar.gz)     tar xzf "$n"    ;;
        *.tgz)        tar xzf "$n"    ;;
        *.tbz2)       tar xjf "$n"    ;;
        *.tar.bz2)    tar xjf "$n"    ;;
        *.bz2)        bunzip2 "$n"    ;;
        *.rar)        unrar x "$n"    ;;
        *.gz)         gunzip "$n"     ;;
        *.zip)        unzip "$n"      ;;
        *.Z)          uncompress "$n" ;;
        *.7z)         7z x "$n"       ;;
        *.xz)         nuxz "$n"       ;;
        *)            echo "'$n' - Unsupported file type." ;;
      esac
    done
  '';
}
