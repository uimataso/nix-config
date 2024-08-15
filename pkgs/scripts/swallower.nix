{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "swallower";
  runtimeInputs = with pkgs; [ xdotool ];

  text = ''
    winid="$(xdotool getactivewindow)"
    xdotool windowunmap "$winid"
    "$@"
    xdotool windowmap "$winid"
  '';
}
