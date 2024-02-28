{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "open";
  runtimeInputs = with pkgs; [
    file
    mpv
    zathura
    nsxiv
    # libreoffice
  ];

  text = ''
    case $(file --mime-type "$1" -bL) in

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

      text/*)
        $${EDITOR} "$@"
        ;;

      *)
        echo "File type '$(file --mime-type "$1" -bL)' not support!" >&2
        exit 1
        ;;
    esac
  ''
}
