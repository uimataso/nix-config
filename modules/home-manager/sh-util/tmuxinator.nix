{ config, lib, pkgs, ... }:

with lib;

# https://github.com/tmuxinator/tmuxinator
# TODO: quick way to add/edit config

let
  cfg = config.myConfig.sh-util.tmuxinator;

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
in {
  options.myConfig.sh-util.tmuxinator = {
    enable = mkEnableOption "tmuxinator";

    dir = mkOption {
      type = types.path;
      default = ./tmuxinator;
      description = "Tmuxinator project directory.";
    };
  };

  config = mkIf cfg.enable {
    myConfig.sh-util.tmux.enable = true;

    programs.tmux.tmuxinator.enable = true;

    home.packages = with pkgs; [
      (callPackage script {})
    ];

    home.shellAliases = {
      ts = "tmuxinator-fzf";
      t = "tmuxinator start default";
    };

    home.file.".config/tmuxinator".source = cfg.dir;
  };
}
