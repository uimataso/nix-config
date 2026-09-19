{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "ux";

  text = ''
    app_name=''${0##*/}
    help() {
      echo "Usage: $app_name [FILE]..."
      cat <<'EOF'
    Unarchive or extract any supported compressed files.

    Supported types (sorted):
      *.7z
      *.bz2
      *.gz
      *.lzma
      *.rar
      *.tar
      *.tar.bz2
      *.tar.gz
      *.tar.lzma
      *.tar.xz
      *.tbz2
      *.tgz
      *.xz
      *.Z
      *.zip
      *.zst
    EOF
    }

    if [ -z "''${1+x}" ]; then
      help >&2
      exit 1
    fi

    for n in "$@"; do
      if [ ! -f "$n" ];then
        echo "$app_name: File '$n' does not exist." >&2
        continue
      fi

      case "''${n%,}" in
        *.tar)              ${pkgs.gnutar}/bin/tar xf "$n"          ;;
        *.tar.xz)           ${pkgs.gnutar}/bin/tar xf "$n"          ;;
        *.tar.gz|*.tgz)     ${pkgs.gnutar}/bin/tar xzf "$n"         ;;
        *.tar.bz2|*.tbz2)   ${pkgs.gnutar}/bin/tar xjf "$n"         ;;
        *.tar.lzma)         ${pkgs.gnutar}/bin/tar --lzma -xf "$n"  ;;

        *.xz)         ${pkgs.xz}/bin/unxz "$n"           ;;
        *.gz)         ${pkgs.toybox}/bin/gunzip "$n"     ;;
        *.bz2)        ${pkgs.toybox}/bin/bunzip2 "$n"    ;;
        *.lzma)       ${pkgs.xz}/bin/unlzma "$n"         ;;
        *.Z)          ${pkgs.gzip}/bin/uncompress "$n"   ;;
        *.zst)       ${pkgs.zstd}/bin/unzstd -d "$n"    ;;

        *.zip)        ${pkgs.unzip}/bin/unzip "$n"       ;;
        *.rar)        ${pkgs.unrar}/bin/unrar x "$n"     ;;
        *.7z)         ${pkgs.p7zip}/bin/7z x "$n"        ;;

        *)            echo "$app_name: Unsupported file type for '$n'." >&2 ;;
      esac
    done
  '';
}
