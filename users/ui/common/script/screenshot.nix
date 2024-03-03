{ writeShellApplication
, pkgs
}: let
  clip_cmd = "${pkgs.xclip}/bin/xclip -selection clipboard -target image/png < $f";
in writeShellApplication {
  name = "screenshot";
  runtimeInputs = with pkgs; [ scrot ];

  text = ''
    [ -z "$1" ] && { echo "Usage: $${0##*/} sel|cur|full" >&2; exit 1; }

    img_dir="$XDG_PICTURES_DIR/screenshots";
    [ ! -d "$img_dir" ] && mkdir -p "$img_dir"

    filename='screenshot_%Y-%m-%d_%H-%M-%S.png';

    # shellcheck disable=SC2016
    case "$1" in
      sel)  scrot -s "$img_dir/$filename" -e '${clip_cmd}' ;;
      cur)  scrot -u "$img_dir/$filename" -e '${clip_cmd}' ;;
      full) scrot "$img_dir/$filename" -e '${clip_cmd}'    ;;
    esac

    notify-send "Screenshot taked"
  '';
}
