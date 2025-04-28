{
  pkgs,
  name, # "note"
  spawnCmd, # "alacritty --class note nvim main.md"
  # TODO: support window rules, like "class:note" "title:Note"
  className, # "note"
}:
let
  openWsPkg = pkgs.writeShellApplication {
    name = "open-ws-${name}";
    runtimeInputs = with pkgs; [ jq ];
    text = ''
      app_ws="$(hyprctl clients -j | jq -r '.[] | select(.class=="${className}") | .workspace.name')"
      if [ -z "$app_ws" ]; then
        # If the app is not opened yet.
        # shellcheck disable=SC2016
        hyprctl dispatch exec '[workspace special:${name}]' '${spawnCmd}'
      elif [ "$app_ws" = 'special:${name}' ]; then
        # If the app is in the special workspace.
        hyprctl dispatch togglespecialworkspace '${name}'
      else
        # If the app is not in the special workspace.
        hyprctl dispatch movetoworkspace special:${name},class:${className}
      fi
    '';
  };

  openPkg = pkgs.writeShellApplication {
    name = "open-${name}";
    runtimeInputs = with pkgs; [ jq ];
    text = ''
      app_ws="$(hyprctl clients -j | jq -r '.[] | select(.class=="${className}") | .workspace.name')"
      cur_ws="$(hyprctl activeworkspace -j | jq -r '.name')"
      if [ -z "$app_ws" ]; then
        # If the app is not opened yet.
        # shellcheck disable=SC2016
        hyprctl dispatch exec '${spawnCmd}'
      elif [ "$app_ws" = "$cur_ws" ]; then
        # If the app is in the current workspace.
        hyprctl dispatch movetoworkspacesilent special:${name},class:${className}
      else
        # If the app is not in the current workspace.
        hyprctl dispatch movetoworkspace "$cur_ws",class:${className}
      fi
    '';
  };

in
pkgs.buildEnv {
  name = "scratchpad-${name}";
  paths = [
    openWsPkg
    openPkg
  ];
}
