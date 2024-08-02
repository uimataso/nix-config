{ ... }:

{
  imports = [
    ./impermanence
    ./auto-upgrade.nix
    ./sops.nix
    ./openssh.nix
    ./pipewire.nix
    ./doas.nix
    ./sudo.nix
    ./udisks2.nix
    ./wsl.nix
  ];
}
