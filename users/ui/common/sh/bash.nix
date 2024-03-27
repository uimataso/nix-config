{ config, ... }:

{
  programs.bash = {
    enable = true;

    historyFile = "${config.xdg.dataHome}/bash_history";
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyIgnore = [ ];

    # verify before run history command
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
