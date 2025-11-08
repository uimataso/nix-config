{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "tmux-select-sessions";
  runtimeInputs = with pkgs; [
    fzf
    tmux
    tmuxinator
  ];
  text = ''
    sessions_list() {
      current_session="$([ -n "''${TMUX+x}" ] && tmux display-message -p -F'#{client_session}' 2>/dev/null)"

      # Get tmux sessions that sort by last attached time
      ( tmux list-sessions -F'#{session_name}:#{session_last_attached}' 2>/dev/null || true ) | sort -r -t':' -k2 | cut -d: -f1 | grep -v "^$current_session$"

      # Get tmux sessions
      tmp="$(mktemp -t tmux-select-sessions.XXXXXXXX)"
      ( tmux list-sessions -F '#{session_name}' 2>/dev/null || true ) | sort > "$tmp"

      # Get tmuxinator project that are not created
      printf '\e[38;5;242m'
      tmuxinator list -n | tail -n+2 | sort | comm "$tmp" - -13
      printf '\e[0m'

      # Get dir in src/* that are not created
      printf '\e[38;5;242m'
      find "$HOME/src/" -mindepth 1 -maxdepth 1 -type d -printf 'src/%P\n' | sort | comm "$tmp" - -13
      printf '\e[0m'

      rm "$tmp"
    }

    selected=$(sessions_list | fzf --height 100% --bind=enter:replace-query+print-query --ansi || true)

    [ -z "$selected" ] && exit

    if ( tmux list-sessions 2>/dev/null || true ) | cut -d: -f1 | grep -x "$selected" >/dev/null; then
      if [ -z "''${TMUX+x}" ]; then
        tmux attach-session -t "$selected"
      else
        tmux switch-client -t "$selected"
      fi
    elif tmuxinator list -n | tail -n+2 | grep -x "$selected" >/dev/null ;then
      tmuxinator start "$selected"
    elif [ -d "$HOME/$selected" ]; then
      if [ -z "''${TMUX+x}" ]; then
        tmux new-session -s "$selected" -c "$HOME/$selected"
      else
        tmux new-session -d -s "$selected" -c "$HOME/$selected"
        tmux switch-client -t "$selected"
      fi
    else
      if [ -z "''${TMUX+x}" ]; then
        tmux new-session -s "$selected"
      else
        tmux new-session -d -s "$selected"
        tmux switch-client -t "$selected"
      fi
    fi
  '';
}
