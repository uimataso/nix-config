{ ... }:
{
  imports = [
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./k8s.nix
    ./lazygit.nix
    ./podman.nix
  ];
}
