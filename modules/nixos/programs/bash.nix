{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.programs.bash;
in
{
  options.uimaConfig.programs.bash = {
    enable = mkEnableOption "Bash XDG-rized";
  };

  config = mkIf cfg.enable {
    # While running init, `$XDG_CONFIG_HOME` not available yet, so `$HOME/.config` is used instead of `$XDG_CONFIG_HOME`
    environment.shellInit =
      # sh
      ''
        if [[ -r "$HOME/.config/bash/profile" ]]; then
          . "$HOME/.config/bash/profile"
        fi
      '';
    environment.interactiveShellInit =
      # sh
      ''
        if [[ -r "$HOME/.config/bash/bashrc" ]]; then
          . "$HOME/.config/bash/bashrc"
        fi
      '';
  };
}
