{ ... }:
{
  imports = [
    ./impermanence
    ./auto-upgrade.nix
    ./sops.nix
    ./openssh.nix
    ./doas.nix
    ./sudo.nix
    ./wsl.nix
  ];
}
