{ pkgs, ... }:

# https://github.com/tmuxinator/tmuxinator
# TODO: quick way to add/edit config

let
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
  programs.tmux.tmuxinator.enable = true;

  home.packages = with pkgs; [
    (callPackage script { })
  ];

  home.shellAliases = {
    ts = "tmuxinator-fzf";
    t = "tmuxinator start default";
  };

  home.file.".config/tmuxinator".source = ./.;
}
