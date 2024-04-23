{ writeShellApplication
, pkgs
}:
let
  # TODO: ls solution
  # exa -a --group-directories-first --color=always --icons
  # ls -A --group-directories-first --color=always
  ls_cmd = "lsd -A --group-directories-first --color=always";
in
writeShellApplication {
  name = "fff";
  runtimeInputs = with pkgs; [
    fzf
    lsd
    (callPackage ./preview.nix { })
    (callPackage ./open.nix { })
  ];

  text = ''
    set +o errexit

    # Temp file
    _fff_up_dir_temp='/tmp/fff-up-dir'

    while :; do
      # prepare the prompt to show current directory
      pwd="$(pwd | sed "s#^$HOME#~#")"

      # shellcheck disable=SC2000
      if [ "$(echo "$pwd" | wc -c)" -gt 25 ]; then
        # only show first char if PWD too long
        pwd="$(printf '%s' "$pwd" | sed 's#\([^/.]\)[^/]\+/#\1/#g')"
      fi

      # shellcheck disable=SC2016
      selected="$(${ls_cmd} "$PWD" |
        fzf --prompt "$pwd/" \
            --preview 'preview $PWD/{}' \
            --preview-window '70%,border-left' \
            --ansi \
            --height 100 \
            --info inline \
            --color prompt:245 \
            --cycle \
            --bind left:"execute(touch $_fff_up_dir_temp)+abort",right:accept \
            --bind ctrl-h:"execute(touch $_fff_up_dir_temp)+abort",ctrl-l:accept
      )"

      # Go upper dir
      if [ -f "$_fff_up_dir_temp" ]; then
        rm -f "$_fff_up_dir_temp"
        cd ..
        continue
      fi

      # TODO: restore setting, need better way to do this
      if [ -z "''${selected:+x}" ]; then
        set +o errexit
        set +o nounset
        set +o pipefail
        return
      fi

      # Open the selected
      file="$selected"
      if [ -d "$file" ]; then
        cd "$file"
      else
        open "$file"
      fi
    done
  '';
}
