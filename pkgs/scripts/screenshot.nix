{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = with pkgs; [
    scrot
    slurp
    grim
  ];

  text = ''
    if [ -z "''${1+x}" ]; then
      echo "Usage: ''${0##*/} sel|cur|full" >&2
      exit 1
    fi

    img_dir="$XDG_PICTURES_DIR/screenshots";
    [ ! -d "$img_dir" ] && mkdir -p "$img_dir"

    filename="$img_dir/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png";

    case "$XDG_SESSION_TYPE" in
      'x11')
        case "$1" in
          sel)  scrot -s "$filename" ;;
          cur)  scrot -u "$filename" ;;
          full) scrot "$filename"    ;;
        esac

        ${pkgs.xclip}/bin/xclip -selection clipboard -target image/png < "$filename"
      ;;
      'wayland')
        case "$1" in
          sel)  grim -g "$(slurp)" "$filename" ;;
          cur)  grim "$filename" ;;
          full) grim "$filename" ;;
        esac

        ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$filename"
      ;;
    esac

    notify-send "Screenshot taked"
  '';
}
