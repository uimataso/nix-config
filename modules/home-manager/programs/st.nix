{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.st;

  scheme = config.stylix.base16Scheme;
in
{
  options.uimaConfig.programs.st = {
    enable = mkEnableOption "st";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use st as default terminal";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ st ];

    home.sessionVariables = mkIf cfg.defaultTerminal {
      TERMINAL = "st";
    };

    xresources.properties = with config.stylix; {
      "st.font" = "${fonts.monospace.name}:size=${builtins.toString fonts.sizes.terminal}";
      "st.cursorColor" = "#${scheme.base05}";
      "st.cwscale" = "0.95";
      "st.shell" = "/bin/bash";
      "st.alpha" = "${builtins.toString opacity.terminal}";
    };
  };
}
