{ pkgs }:
let
  initScript = # sh
    ''
      APP_NAME=''${0##*/}

      debug() {
        echo "$APP_NAME: $*"
      }
    '';

  mkScriptWith = fn: args: pkgs.callPackage fn ({ inherit initScript; } // args);
  mkScript = fn: mkScriptWith fn { };
in
{
  scripts = rec {
    # Nix utils
    nix-template-tool = mkScript ./nix-template-tool.nix;

    # Utils
    fff = mkScriptWith ./fff.nix { inherit preview open; };
    ux = mkScript ./ux.nix;
    pdf-decrypt = mkScript ./pdf-decrypt.nix;
    mkbigfile = mkScript ./mkbigfile.nix;
    open = mkScript ./open.nix;
    preview = mkScript ./preview.nix;
    fetch-title = mkScript ./fetch-title.nix;
    notify-send-all = mkScript ./notify-send-all.nix;

    # Dmenu
    app-launcher = mkScript ./app-launcher.nix;
    power-menu = mkScript ./power-menu.nix;

    # System
    vl = mkScript ./vl.nix;
    clip = mkScript ./clip.nix;

    # Tmux
    tmux-select-sessions = mkScript ./tmux-select-sessions.nix;

    # Desktop
    fmenu = mkScript ./fmenu.nix;
    screenshot = mkScriptWith ./screenshot.nix { inherit clip; };
  };
}
