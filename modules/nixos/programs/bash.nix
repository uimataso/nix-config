{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.programs.bash;
in
{
  options.myConfig.programs.bash = {
    enable = mkEnableOption "Bash XDG-rized";
  };

  config = mkIf cfg.enable {
    # While running init, XDG_CONFIG_HOME not available yet, so $HOME/.config is used there
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
  };
}
