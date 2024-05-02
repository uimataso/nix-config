{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "nix-template-tool";
  runtimeInputs = with pkgs; [
    jq
    fzf
  ];

  text = ''
    flake_home="''${FLAKE_HOME:-$HOME/nix}"

    gray=$(tput setaf 247)
    reset=$(tput sgr0)

    # Select template
    selected="$(nix eval -f "$flake_home/templates" --json \
      | jq --arg gray "$gray" --arg reset "$reset" -r \
        'keys[] as $k | $k + "\t" + $gray + (.[$k] | .description) + $reset' \
      | column -t -s "$(printf '\t')" \
      | fzf --ansi \
      | cut -f1 -d' ')"

    [ -z "$selected" ] && exit

    # Select action
    declare -a cmds
    cmds=(new init)
    cmd="$(printf '%s\n' "''${cmds[@]}" | fzf)"

    [ -z "$cmd" ] && exit 1

    # Enter project name
    printf 'Please enter project name: '
    read -r project_name
    [ -z "$project_name" ] && exit 1

    project_code_name="$(printf '%s' "$project_name" | tr '[:upper:]' '[:lower:]' | sed 's/\s\+/-/g' )"

    if [ -e "$project_code_name" ]; then
      printf 'File %s exist' "$project_code_name" >&2
      exit 1
    fi

    # Do action
    case "$cmd" in
      'new') nix flake "$cmd" "$project_code_name" -t "$flake_home#$selected" ;;
      'init') nix flake "$cmd" -t "$flake_home#$selected" ;;
    esac

    # Replace template placeholder
    case "$cmd" in
      'new') target_dir="$project_code_name" ;;
      'init') target_dir='.' ;;
    esac

    while IFS= read -r -d "" file; do
      sed -i "s/{{NAME}}/$project_name/g" "$file"
      sed -i "s/{{CODENAME}}/$project_code_name/g" "$file"
    done < <(find "$target_dir" -type f -print0)
  '';
}
