{
  writeShellApplication,
  pkgs,
  clip,
  initScript,
  ...
}:
writeShellApplication {
  name = "0x0";
  runtimeInputs = with pkgs; [
    curl

    clip
  ];

  text = ''
    ${initScript}

    if [ ! -t 0 ]; then
        curl -sS -F "file=@-" https://0x0.st | clip
    elif [ -f "''${1:-}" ]; then
        curl -sS -F "file=@$1" https://0x0.st | clip
    else
        echo "Usage: $APP_NAME [filename]" >&2
        exit 1
    fi
  '';
}
