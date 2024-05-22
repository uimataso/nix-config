{ config, lib, pkgs, ... }:

# https://github.com/tmuxinator/tmuxinator

with lib;

let
  cfg = config.uimaConfig.sh-util.tmuxinator;

  script = { writeShellApplication, pkgs }:
    writeShellApplication {
      name = "tmuxinator-fzf";
      runtimeInputs = with pkgs; [ fzf tmux tmuxinator ];
      text = ''
        selected="$(tmuxinator list -n | tail -n +2 | fzf || true)"
        test -z "$selected" && exit
        tmuxinator s "$selected"
      '';
    };
in
{
  options.uimaConfig.sh-util.tmuxinator = {
    enable = mkEnableOption "tmuxinator";

    dir = mkOption {
      type = types.path;
      default = ./tmuxinator;
      description = "Tmuxinator project directory.";
    };
  };

  config = mkIf cfg.enable {
    uimaConfig.sh-util.tmux.enable = true;

    programs.tmux.tmuxinator.enable = true;

    home.packages = with pkgs; [
      (callPackage script { })
    ];

    home.shellAliases = {
      ts = "tmuxinator-fzf";
      td = "tmuxinator start default";
    };

    xdg.configFile = {
      "tmuxinator".source = cfg.dir;
    };
  };
}
