# vim:foldmethod=marker:foldlevel=0
{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "preview";

  text = ''
    ls_cmd="''${PREVIEW_LS_CMD:-ls -A --group-directories-first --color=always}"
    ls_l_cmd="''${PREVIEW_LS_L_CMD:-ls -l --color=always}"

    dir_info() { #{{{
      normal=$(tput sgr0)
      green=$(tput setaf 2 bold)

      printf '%s %s  %s %s  %s %s' \
        "''${green}Total:''${normal}" \
        "$(find -L "$1" -maxdepth 1 -mindepth 1 | wc -l)" \
        "''${green}Dir:''${normal}" \
        "$(find -L "$1" -maxdepth 1 -mindepth 1 -type d | wc -l)" \
        "''${green}File:''${normal}" \
        "$(find -L "$1" -maxdepth 1 -mindepth 1 -type f | wc -l)"

      # if directory is symbolic link
      if [ -h "$1" ]; then
        blue=$(tput setaf 4 bold)
        printf "\t\t->''${blue}%s''${normal}" "$(realpath "$1")"
      fi

      printf '\n'
    } #}}}
    file_info(){ #{{{
      $ls_l_cmd "$1" | sed "s#^$HOME#~#"
      printf '\n'
    } #}}}
    view_dir(){ #{{{
      $ls_cmd "$1"
    } #}}}
    view_text(){ #{{{
      ${pkgs.bat}/bin/bat -n --style=plain --pager=never --color=always "$1"
    } #}}}

    if [ -z "''${1+x}" ]; then
      echo "Usage: ''${0##*/} filename" >&2
      exit 1
    fi

    file="$1"

    if [ -d "$file" ]; then
      dir_info "$file"
      view_dir "$file"
      exit
    fi

    if [ ! -f "$file" ]; then
      echo 'File not found!' >&2
      exit 1
    fi

    file_info "$file"

    case $(readlink -f "$file" | tr '[:upper:]' '[:lower:]') in
      *.tgz|*.tar.gz)   ${pkgs.gnutar}/bin/tar tzf "$file" ;;
      *.tar.bz2|*.tbz2) ${pkgs.gnutar}/bin/tar tjf "$file" ;;
      *.tar.txz|*.txz)  ${pkgs.xz}/bin/xz --list "$file" ;;
      *.tar)            ${pkgs.gnutar}/bin/tar tf "$file" ;;
      *.zip|*.jar|*.war|*.ear|*.oxt) ${pkgs.unzip}/bin/unzip -l "$file" ;;
      *.rar)  ${pkgs.unrar}/bin/unrar l "$file" ;;
      *.7z)   ${pkgs.p7zip}/bin/7z l "$file" ;;

      *.[1-8]) man "$file" | col -b ;;

      *.png|*.jpg|*.jpeg|*.webp|*.gif) ${pkgs.chafa}/bin/chafa --animate=off --view-size=x"$(( LINES - 2 ))" "$file" ;;

      # *.pdf) ;;

      *.json) ${pkgs.jq}/bin/jq -C . "$file" ;;

      *) view_text "$file" ;;
    esac
  '';
}
