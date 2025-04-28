{ writeShellApplication, pkgs }:
writeShellApplication {
  name = "fetch-title";
  runtimeInputs = with pkgs; [
    curl
  ];

  text = ''
    help() {
      echo 'Usage: fetch-title <url>'
    }

    if [ -z "$1" ]; then
      help >&2
      exit 1
    fi

    curl -sL "$1" | grep -oP '(?<=<title>).*?(?=</title>)'
  '';
}
