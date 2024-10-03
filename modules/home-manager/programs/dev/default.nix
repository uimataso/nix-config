{ ... }:
{
  imports = [
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./k8s.nix
    ./lazydocker.nix
    ./lazygit.nix
    ./podman.nix
    ./ssh.nix
  ];
}
