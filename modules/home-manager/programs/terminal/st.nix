{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.uimaConfig.programs.terminal.st;
in
{
  options.uimaConfig.programs.terminal.st = {
    enable = mkEnableOption "st";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use st as default terminal";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (st.overrideAttrs {
        src = fetchFromGitHub {
          owner = "uimataso";
          repo = "st";
          rev = "7cf4187e0b931a906770b4fa5f00d4d884473e4b";
          sha256 = "sha256-N5TRSVfBHm6B3PfeR6PR7nPF2dL4ad9LJaQGIPRQ3cA=";
        };
      })
    ];

    uimaConfig.programs.terminal = mkIf cfg.defaultTerminal {
      enable = true;
      executable = "st";
    };

    xresources.properties =
      with config.lib.stylix.colors.withHashtag;
      with config.stylix;
      {
        "st.font" = "${fonts.monospace.name}:size=${builtins.toString fonts.sizes.terminal}";
        "st.cursorColor" = base05;
        "st.cwscale" = "0.95";
        "st.shell" = "/bin/bash";
        "st.alpha" = "${builtins.toString opacity.terminal}";
        "Xft.dpi" = 96;
        "Xft.antialias" = true;
        "Xft.hinting" = true;
        "Xft.rgba" = "rgb";
        "Xft.autohint" = true;
        "Xft.hintstyle" = "hintfull";
        "Xft.lcdfilter" = "lcdfilter";
      };
  };
}
