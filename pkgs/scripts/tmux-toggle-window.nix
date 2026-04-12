{
  writeShellApplication,
  pkgs,
  ...
}:
writeShellApplication {
  name = "tmux-toggle-window";
  runtimeInputs = with pkgs; [
    tmux
  ];

  text = ''
    if [ -z "''${TMUX+x}" ]; then
      echo 'not in the tmux' >&2
      exit 1
    fi

    name="$1"
    cmd="$*"

    current_session="$(tmux display-message -p -F'#{client_session}' 2>/dev/null)"

    if echo "$current_session" | grep "^.*_popup$"; then
      tmux detach-client
    fi

    current_window_name="$(tmux display-message -p -F'#{window_name}' 2>/dev/null)"

    if [ "$current_window_name" = "$name" ]; then
      tmux last-window
    else
      tmux new-window -S -n "$name" -c "#{pane_current_path}" "$cmd"
    fi
  '';
}
