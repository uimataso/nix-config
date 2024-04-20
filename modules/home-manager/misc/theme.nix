{ config, lib, inputs, ... }:

# TODO: try this:
# https://github.com/SenchoPens/base16.nix

with lib;

let
  cfg = config.uimaConfig.misc.theme;
in
{
  options.uimaConfig.misc.theme = {
    enable = mkEnableOption "theme";
  };

  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    colorScheme = inputs.nix-colors.lib.schemeFromYAML "cool-scheme"
      (builtins.readFile ./ui-colors.yaml);
  };
}
