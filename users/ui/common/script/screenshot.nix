{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "screenshot";
  runtimeInputs = with pkgs; [ scrot ];
  text = ''
    [ -z "$1" ] && { echo "Usage: $${0##*/} sel|cur|full" >&2; exit 1; }

    img_dir="$XDG_PICTURES_DIR/img/screenshots";
    [ ! -d "$img_dir" ] && mkdir -p "$img_dir"

    filename='screenshot_%Y-%m-%d_%H-%M-%S.png';
    # TODO: wayland sup
    # shellcheck disable=SC2016
    xclip_cmd='xclip -selection clipboard -target image/png < $f';

    case "$1" in
      sel)  scrot -s "$img_dir/$filename" -e "$xclip_cmd" ;;
      cur)  scrot -u "$img_dir/$filename" -e "$xclip_cmd" ;;
      full) scrot "$img_dir/$filename" -e "$xclip_cmd"    ;;
    esac

    notify-send "Screenshot taked"
  '';
}
