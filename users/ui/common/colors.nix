{ inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.lib.schemeFromYAML "cool-scheme"
    (builtins.readFile ../theme/ui-colors.yaml);
}
