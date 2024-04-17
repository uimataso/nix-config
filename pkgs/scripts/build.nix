{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "build";
  runtimeInputs = with pkgs; [
    git
    home-manager
  ];

  text = ''
    case "''${1:-}" in
      'n') nixos-rebuild switch --flake "/home/ui/nix#$(hostname)" ;;
      'h') home-manager switch --flake "/home/ui/nix#$(whoami)@$(hostname)" ;;
      'nt') nixos-rebuild test --flake "/home/ui/nix#$(hostname)" ;;
    esac
  '';
}
