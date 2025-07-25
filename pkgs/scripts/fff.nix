{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "fff";
  runtimeInputs = with pkgs; [
    fzf
    (callPackage ./preview.nix { })
    (callPackage ./open.nix { })
  ];

  # Disable options `errexit`, `nounset` and `pipefail`
  bashOptions = [ ];

  text = ''
    ls_cmd="''${FFF_LS_CMD:-ls -A --group-directories-first --color=always}"

    # Temp file
    _fff_up_dir_temp='/tmp/fff-up-dir'

    while :; do
      # prepare the prompt to show current directory
      pwd="$(pwd | sed "s#^$HOME#~#")"

      if [ "''${#pwd}" -gt 25 ]; then
        # only show first char if PWD too long
        pwd="$(printf '%s' "$pwd" | sed 's#\([^/.]\)[^/]\+/#\1/#g')"
      fi

      # shellcheck disable=SC2016
      selected="$($ls_cmd "$PWD" |
        fzf --prompt "$pwd/" \
            --preview 'preview "$PWD"/{}' \
            --preview-window '70%,border-left' \
            --ansi \
            --height 100 \
            --reverse \
            --info inline \
            --no-separator \
            --color prompt:245 \
            --cycle \
            --bind left:"execute(touch $_fff_up_dir_temp)+abort",right:accept \
            --bind ctrl-h:"execute(touch $_fff_up_dir_temp)+abort",ctrl-l:accept \
            --bind pgup:preview-up \
            --bind pgdn:preview-down
      )"

      # Go upper dir
      if [ -f "$_fff_up_dir_temp" ]; then
        rm -f "$_fff_up_dir_temp"
        cd ..
        continue
      fi

      if [ -z "''${selected:+x}" ]; then
        break
      fi

      # Open the selected
      file="$selected"
      if [ -d "$file" ]; then
        cd "$file" || return
      else
        open "$file"
      fi
    done
  '';
}
