{ ... }:

{
  # XDG_CONFIG_HOME not available yet, so $HOME/.config is used
  environment.shellInit = ''
    if [[ -r "$HOME/.config/bash/profile" ]]; then
      . "$HOME/.config/bash/profile"
    fi
  '';
  environment.interactiveShellInit = ''
    if [[ -r "$HOME/.config/bash/bashrc" ]]; then
      . "$HOME/.config/bash/bashrc"
    fi
  '';
}
