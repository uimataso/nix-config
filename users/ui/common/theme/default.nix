{ inputs, ... }:

# TODO: try this:
# https://github.com/SenchoPens/base16.nix

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.lib.schemeFromYAML "cool-scheme"
    (builtins.readFile ./ui-colors.yaml);
}
