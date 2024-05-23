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

    xresources.properties = {
      "st.font" = "${config.stylix.fonts.monospace.name}:size=11";
      "st.cursorColor" = "#${scheme.base05}";
      "st.cwscale" = "0.95";
      "st.shell" = "/bin/bash";
      "st.alpha" = "${builtins.toString config.stylix.opacity.terminal}";
    };
  };
}
