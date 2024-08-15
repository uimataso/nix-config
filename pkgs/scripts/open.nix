{
  writeShellApplication,
  pkgs,
}:
writeShellApplication {
  name = "open";
  runtimeInputs = with pkgs; [xdg-utils];

  text = ''
    if [ -z ''${1:+x} ]; then
      echo "Usage: ''${0##*/} filename" >&2
      exit 1
    fi

    case $(xdg-mime query filetype "$1") in
      video/* | audio/*)
        mpv "$@"
        ;;

      application/pdf |\
      application/postscript |\
      application/x-mobipocket-ebook |\
      application/epub+zip |\
      image/vnd.djvu)
        zathura "$@"
        ;;

      image/*)
        nsxiv "$@"
        ;;

      application/msword |\
      application/vnd.ms-powerpoint |\
      application/vnd.openxmlformats-officedocument.presentationml.presentation)
        libreoffice "$@"
        ;;

      *) ''${EDITOR:-nano} "$@" ;;
    esac
  '';
}
