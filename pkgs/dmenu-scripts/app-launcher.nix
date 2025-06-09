{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "app-launcher";
  runtimeInputs = with pkgs; [
    dex
  ];

  text = ''
    dmenu="''${DMENU:-dmenu -i}"
    term="''${TERMINAL:-st} -e sh -c";

    declare -A apps
    apps=()

    for data_dir in $(echo "$XDG_DATA_DIRS" | tr ':' '\n'); do
      apps_dir="$data_dir/applications"
      if [ ! -d "$apps_dir" ]; then
        continue
      fi

      # shellcheck disable=SC2044
      for file in $(find "$apps_dir" -name '*.desktop'); do
        # Skip the app that no display
        if grep '^NoDisplay=true' "$file" >/dev/null; then
          continue
        fi

        name="$(sed -n 's/^Name=\(.*\)/\1/p;/^\[Desktop Action.*/q' "$file")"

        case "$name" in
          ''' | .* | 'Htop' | 'Remote Viewer' | 'XTerm')
            continue ;;
          *) ;;
        esac

        apps["$name"]="$file"
      done
    done

    selected="$(printf '%s\n' "''${!apps[@]}" | $dmenu)"

    if [ -z "$selected" ]; then
      exit
    fi

    case "$selected" in
      # exec command in terminal if query start or end with ';'
      *\;) $term "''${selected%\;}" ;;
      \;*) $term "''${selected#\;}" ;;

      # search if query start or end with '/'
      # TODO: search-query not implement/import yet
      # */) xdg-open "$(search-query "''${selected%/}")" ;;
      # /*) xdg-open "$(search-query "''${selected#/}")" ;;

      # exec selected
      *) dex "''${apps["$selected"]}"
    esac
  '';
}
