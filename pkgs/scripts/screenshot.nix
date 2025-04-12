{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = with pkgs; [
    scrot
    slurp
    grim
    (callPackage ./clip.nix { })
  ];

  text = ''
    app_name=''${0##*/}

    help() {
        echo "Usage: $app_name sel|cur|full"
    }

    if [ -z "''${1+x}" ]; then
      help >&2
      exit 1
    fi

    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
      echo "$app_name: No GUI session detected" >&2
      exit 1
    fi

    img_dir="$XDG_PICTURES_DIR/screenshots";
    [ ! -d "$img_dir" ] && mkdir -p "$img_dir"

    filename="$img_dir/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png";

    session_type="''${XDG_SESSION_TYPE:-unknown}"

    case "$session_type" in
      'x11')
        case "$1" in
          sel)  scrot -s "$filename" ;;
          cur)  scrot -u "$filename" ;;
          full) scrot "$filename"    ;;
        esac
      ;;

      'wayland')
        case "$1" in
          sel)  grim -g "$(slurp)" "$filename" ;;
          cur)  grim "$filename" ;;
          full) grim "$filename" ;;
        esac
      ;;

      *)
        echo "$app_name: Not supported session type '$XDG_SESSION_TYPE'" >&2
        exit 1
      ;;
    esac

    clip --mime image/png < "$filename"
    notify-send 'Screenshot taken' "Stored at '$filename'"
  '';
}
