{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util;
in
{
  imports = [
    ./aerc.nix
    ./eza.nix
    ./fff.nix
    ./fzf.nix
    ./htop.nix
    ./lsd.nix
    ./neomutt.nix
    ./nix-helper.nix
    ./tealdeer.nix
    ./tmux.nix
  ];

  options.uimaConfig.programs.sh-util = {
    default = mkEnableOption "Default sh-util.";
  };

  config = mkIf cfg.default {
    home.packages = with pkgs; [
      lm_sensors

      ffmpeg
      dust

      scripts.clip
      scripts.ux
      scripts.open
      scripts.preview
    ];

    programs = {
      btop.enable = true;
      ripgrep.enable = true;
      fd.enable = true;
      jq.enable = true;
      bat.enable = true;
    };

    uimaConfig.programs.sh-util = {
      htop.enable = true;
      fzf.enable = true;
      fff.enable = true;
      tealdeer.enable = true;
    };

    home.shellAliases = {
      o = "open";
      y = "clip";
    };
  };
}
