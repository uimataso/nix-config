{ ... }:
{
  imports = [
    ./aws-cli.nix
    ./direnv.nix
    ./docker.nix
    ./gh.nix
    ./git.nix
    ./k8s.nix
    ./lazydocker.nix
    ./lazygit.nix
    ./podman.nix
    ./ssh.nix
    ./terraform.nix
  ];
}
