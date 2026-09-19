{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "open-git-remote";
  runtimeInputs = with pkgs; [
    git
    xdg-utils
  ];

  text = ''
    git_remote="$(git remote get-url origin)"

    if [ -z "$git_remote" ]; then
      echo "git remote not found" >&2
      exit 1
    fi

    case "$git_remote" in
      http*) url="$git_remote" ;;
      git@github.com:*)
        # shellcheck disable=SC2001
        url="$(echo "$git_remote" | sed 's#[^:]*:\(.*\).git#https://github.com/\1#')"
        ;;
      *)
        echo "unknown git url: $git_remote"
        exit 1
        ;;
    esac

    xdg-open "$url"
  '';
}
