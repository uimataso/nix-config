{
  writeShellApplication,
  pkgs,
}:
writeShellApplication {
  name = "vl";
  runtimeInputs = with pkgs; [
    pulseaudio # bin/pactl
  ];

  text = ''
    up() {
      [ -n "$1" ] && STEP=$1
      vol="$(get_volume)"
      pactl set-sink-volume @DEFAULT_SINK@ "$(( STEP * (vol / STEP +1) ))"%
    }

    down() {
      [ -n "$1" ] && STEP=$1
      pactl set-sink-volume @DEFAULT_SINK@ -"$STEP"%
    }

    sink_mute() {
      pactl set-sink-mute @DEFAULT_SINK@ toggle
    }

    source_mute() {
      pactl set-source-mute @DEFAULT_SOURCE@ toggle
    }

    switch() {
      def=$(pactl get-default-sink)
      pactl list short sinks | cut -f2 | tr '\n' ' ' |
        sed "s/^.*$def \(\S*\) .*/\1/" | # look for next sink
        sed "s/^\(\S*\) .*/\1/" | # if $def is last, look for first
        xargs pactl set-default-sink
    }

    get_volume() {
      if [ "$(pactl get-sink-mute @DEFAULT_SINK@)" = 'Mute: yes' ]; then
        printf 'muted\n'
        return
      fi
      pactl get-sink-volume @DEFAULT_SINK@ | sed 's/.* \([0-9]*\)% .*/\1/; q'
    }

    STEP=5

    case "''${1:-}" in
      u|up) up "''${2:-$STEP}" ;;
      d|down) down "''${2:-$STEP}" ;;
      mute|sink-mute) sink_mute ;;
      source-mute) source_mute ;;
      switch) switch ;;
      ""|get-volume) get_volume ;;
      *) echo "''${0##*/}: option $1 not found." >&2 && exit 1;;
    esac

    # update bar
    # sb-update sb-vol
  '';
}
