{ config, ... }:

# TODO:
# prompt:
# - which nix shell, env im in
# - git branch?
# - direnv ($DIRENV_FILE)

{
  programs.bash = {
    enable = true;

    historyFile = "${config.xdg.dataHome}/bash_history";
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyIgnore = [ ];

    # verify before run his command
    # shopt -s histverify

    bashrcExtra = builtins.readFile ./bashrc;
  };

  # XDG-ly
  home.file = {
    ".bashrc".enable = false;
    "${config.xdg.configHome}/bash/bashrc".source = config.home.file.".bashrc".source;

    ".profile".enable = false;
    "${config.xdg.configHome}/bash/profile".source = config.home.file.".profile".source;

    ".bash_profile".enable = false;
  };
}
