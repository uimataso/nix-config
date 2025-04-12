{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "pdf-decrypt";
  runtimeInputs = with pkgs; [ qpdf ];

  text = ''
    help() {
      echo "Usage: ''${0##*/} password /path/to/pdf [/path/to/the/output]"
      cat <<EOF
    Decrypts a password-protected PDF file

    Will replace the original PDF if not provide output path.
    EOF
    }

    if [ $# -ne 2 ] && [ $# -ne 3 ];then
      help >&2
      exit 1
    fi

    if [ -z "$3" ] || [ "$2" = "$3" ]; then
      # Decrypt in place
      qpdf --replace-input -password="$1" -decrypt "$2"
    else
      qpdf -password="$1" -decrypt "$2" "$3"
    fi
  '';
}
