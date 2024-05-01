{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "pdf-decrypt";
  runtimeInputs = with pkgs; [
    qpdf
  ];

  text = ''
    if [ $# -ne 2 ] && [ $# -ne 3 ];then
      echo "Usage: ''${0##*/} password /path/to/pdf [/path/to/the/output]" >&2
      echo "Replace original pdf if not provide output" >&2
      exit 1
    fi

    if [ -z "$3" ] || [ "$2" = "$3" ]; then
      # Decrypt inplaced
      qpdf --replace-input -password="$1" -decrypt "$2"
    else
      qpdf -password="$1" -decrypt "$2" "$3"
    fi
  '';
}
