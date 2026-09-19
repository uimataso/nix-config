{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "nix-template-tool";
  runtimeInputs = with pkgs; [
    jq
    fzf
  ];

  text = ''
    flake_home="''${FLAKE_HOME:-$HOME/nix}"

    gray=$(tput setaf 8)
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
    cmds () {
      printf 'new    %sCreate a new directory%s\n' "''${gray}" "''${reset}"
      printf 'init   %sApply template at current directory%s\n' "''${gray}" "''${reset}"
    }
    cmd="$(cmds | fzf --ansi | cut -f1 -d ' ')"

    case "$cmd" in
      'new') printf 'Selected new\n' ;;
      'init') printf 'Selected init\n' ;;
      *) printf 'abort' >&2; exit 1 ;;
    esac

    # Enter project name
    printf 'Please enter project name: '
    read -r project_name
    if [ -z "$project_name" ]; then
      printf 'abort' >&2
      exit 1
    fi

    project_code_name="$(printf '%s' "$project_name" | tr '[:upper:]' '[:lower:]' | sed 's/\s\+/-/g' )"

    if [ -e "$project_code_name" ]; then
      printf 'File %s exist\n' "$project_code_name" >&2
      exit 1
    fi

    case "$cmd" in
      'new')
        target_dir="$project_code_name"
        nix flake "$cmd" "$project_code_name" -t "$flake_home#$selected"
        ;;
      'init')
        target_dir='.'
        nix flake "$cmd" -t "$flake_home#$selected"
        ;;
    esac

    while IFS= read -r -d "" file; do
      sed -i "s/{{NAME}}/$project_name/g" "$file"
      sed -i "s/{{CODENAME}}/$project_code_name/g" "$file"
    done < <(find "$target_dir" -type f -print0)
  '';
}
