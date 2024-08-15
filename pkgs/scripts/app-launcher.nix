{
  writeShellApplication,
  pkgs,
}:
writeShellApplication {
  name = "app-launcher";
  runtimeInputs = with pkgs; [
    dex
    (callPackage ./fmenu.nix {})
  ];

  text = ''
    dmenu="''${DMENU:-dmenu -i}"
    term="''${TERMINAL:-st} -e sh -c";

    declare -A apps
    apps=()

    declare -a not_include
    not_include=('Htop' 'Remote Viewer' 'XTerm')

    for data_dir in $(echo "$XDG_DATA_DIRS" | tr ':' '\n'); do
      apps_dir="$data_dir/applications"
      if [ ! -d "$apps_dir" ]; then
        continue
      fi

      # shellcheck disable=SC2044
      for file in $(find "$apps_dir" -name '*.desktop'); do
        name="$(sed -n 's/^Name=\(.*\)/\1/p;/^\[Desktop Action.*/q' "$file")"
        if [ -z "$name" ]; then
          continue
        fi
        if printf '%s\n' "''${not_include[@]}" | grep -Fqx "$name"; then
          continue
        fi

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
