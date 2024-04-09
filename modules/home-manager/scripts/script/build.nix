{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "build";
  runtimeInputs = with pkgs; [
    git
  ];

  text = ''
    case "''${1:-}" in
      'h') home-manager switch --flake "/home/ui/nix#$(whoami)@$(hostname)" ;;
      'n') nixos-rebuild switch --flake "/home/ui/nix#$(hostname)" ;;
    esac
  '';
}
