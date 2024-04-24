{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.uimaConfig.misc.theme;
in
{
  options.uimaConfig.misc.theme = {
    enable = mkEnableOption "theme";

    scheme = mkOption {
      type = types.path;
      default = ./base16-uicolor.yaml;
      description = "Base16 color scheme to use.";
    };
  };

  imports = [
    inputs.base16.nixosModule
  ];

  # https://github.com/SenchoPens/base16.nix
  # https://github.com/chriskempson/base16-templates-source

  config = mkIf cfg.enable {
    scheme = "${cfg.scheme}";
  };
}

# 0 "#161616"
# 1 "#1e1e1e"
# 2 "#272727"
# 3 "#373737"
# 4 "#585858"
# 5 "#808080"
# 6 "#9b9b9b"
# 7 "#bcbcbc"
# 8 "#c68586"
# 9 "#edb96e"
# A "#d5be95"
# B "#86a586"
# C "#8caeaf"
# D "#83a0af"
# E "#d8afad"
# F "#b08b76"
