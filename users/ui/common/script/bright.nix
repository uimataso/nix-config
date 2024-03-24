{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "bright";

  text = ''
    # dev='/sys/class/backlight/intel_backlight'
    dev="$(echo /sys/class/backlight/*)"
    if [ ! -d "$dev" ]; then
      echo "''${0##*/}: backlight not found!" >&2
      exit 1
    fi

    val="$(cat "$dev/brightness")"
    max="$(cat "$dev/max_brightness")"
    step=$(( max / 15 ))

    change_bright() {
      next=$((val + $1))
      if [ "$next" -ge "$max" ]; then
        echo "$max"
      elif [ "$next" -le "$step" ]; then
        echo "$step"
      else
        echo "$next"
      fi > "$dev/brightness"
    }

    get(){
      echo "$val"
    }
    max(){
      echo "$max"
    }
    up(){
      change_bright "+$step"
    }
    down(){
      change_bright "-$step"
    }

    "$@"

    # update bar
    #sb-update sb-brightness
  '';
}
