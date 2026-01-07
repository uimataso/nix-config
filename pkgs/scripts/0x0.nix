{
  writeShellApplication,
  pkgs,
  clip,
  ...
}:
writeShellApplication {
  name = "0x0";
  runtimeInputs = with pkgs; [
    curl

    clip
  ];

  text = ''
    help() {
      echo "Usage:"
      echo "    $APP_NAME <filename>      upload file"
      echo "    $APP_NAME                 upload clipboard"
    }

    if [ ! -t 0 ]; then
        curl -sS -F "file=@-" https://0x0.st | clip
    elif [ -f "''${1:-}" ]; then
        curl -sS -F "file=@$1" https://0x0.st | clip
    else
        help >&2
        exit 1
    fi
  '';
}
