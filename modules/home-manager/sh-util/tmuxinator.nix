{ config, lib, pkgs, ... }:

# https://github.com/tmuxinator/tmuxinator

with lib;

let
  cfg = config.uimaConfig.sh-util.tmuxinator;

  tmuxinator-fzf = { writeShellApplication, pkgs }:
    writeShellApplication {
      name = "tmuxinator-fzf";
      runtimeInputs = with pkgs; [ fzf tmux tmuxinator ];
      text = ''
        selected="$(tmuxinator list -n | tail -n +2 | fzf || true)"
        test -z "$selected" && exit
        tmuxinator s "$selected"
      '';
    };

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.sh-util.tmuxinator = {
    enable = mkEnableOption "tmuxinator";
  };

  config = mkIf cfg.enable {
    uimaConfig.sh-util.tmux.enable = true;

    programs.tmux.tmuxinator.enable = true;

    home.packages = with pkgs; [
      (callPackage tmuxinator-fzf { })
    ];

    home.shellAliases = {
      ts = "tmuxinator-fzf";
      td = "tmuxinator start default";
    };

    home.persistence.main = mkIf imper.enable {
      directories = [ ".config/tmuxinator" ];
    };
  };
}
