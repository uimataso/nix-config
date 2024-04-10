{ pkgs, inputs, outputs, ... }:

{
  imports = [
    ./sh
    ./sh-util
    ./dev
    ./programs
    ./services
    ./desktop
    ./misc
  ] ++ [
    # TODO: make it's own module
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  # Global settings
  nixpkgs.overlays = [
    inputs.nur.overlay
  ] ++ builtins.attrValues outputs.overlays;

  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  news.display = "silent";
}
