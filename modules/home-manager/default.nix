{ pkgs, inputs, outputs, ... }:

{
  imports = [
    ./system
    ./sh
    ./sh-util
    ./dev
    ./programs
    ./services
    ./desktop
    ./misc
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
