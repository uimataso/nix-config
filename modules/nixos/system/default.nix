{ ... }:

{
  imports = [
    ./impermanence
    ./sops.nix
    ./auto-upgrade.nix
    ./doas.nix
    ./sudo.nix
  ];
}
