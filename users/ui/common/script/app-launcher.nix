{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "app-launcher";
  runtimeInputs = with pkgs; [ ];

  text = ''
    dmenu="''${DMENU:-dmenu -i}"
    term="''${TERMINAL:-st} -e sh -c"
    temp_file='/tmp/launcher_temp'

    cleanup() {
      rm -f $temp_file
      exit
    }
    trap cleanup EXIT INT TERM

    _path(){
      file="$(echo "$PATH" | tr ':' '\n' | xargs ls 2>/dev/null || true)"
      echo "$file" | sed '/^\//d; /^$/d' | sort | uniq
    }
    _app(){
      find "$XDG_DATA_HOME/applications" -type f | sort
    }

    printf 'url-bookmark\n' > "$temp_file"
    _path >> "$temp_file"
    _app >> "$temp_file"

    selected="$($dmenu -p "RUN" < "$temp_file")"

    [ -z "$selected" ] && exit

    case "$selected" in
      # exec command in terminal if query start or end with ';'
      *\;) $term "''${selected%\;}" ;;
      \;*) $term "''${selected#\;}" ;;

      # search if query with ':'
      */) xdg-open "$(search-query "''${selected%/}")" ;;
      /*) xdg-open "$(search-query "''${selected#/}")" ;;

      # desktop applications
      *.desktop) gtk-launch "$selected" ;;

      # exec selected
      *) $selected
    esac
  '';
}
