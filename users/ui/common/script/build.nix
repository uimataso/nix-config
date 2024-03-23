{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "build";
  text = ''
    case "''${1:-}" in
      'h') home-manager switch --flake "/home/ui/nix#$(whoami)@$(hostname)" ;;
      'n') nixos-rebuild switch --flake "/home/ui/nix#$(hostname)" ;;
    esac
  '';
}
