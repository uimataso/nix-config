{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.bash;

  imper = config.uimaConfig.system.impermanence;
  rmHomePath = str: removePrefix config.home.homeDirectory str;

  # Plugins
  # TODO: move these to pkgs
  fzf-key-bindings = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/fzf/0.49.0/shell/key-bindings.bash";
    sha256 = "002vls06ws858jyjzaba852ih81vqfnjsyxd8c1v7s8dw08wx3jn";
  };
  fzf-completion = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/lincheney/fzf-tab-completion/97658f9f6370606cf337ef04c6b8553d1daf51cc/bash/fzf-bash-completion.sh";
    sha256 = "15wbd45xxwiv6db34gm1x7czcy181kak8wby4k3gy9ahskwmsp5f";
  };
in
{
  options.uimaConfig.sh.bash = {
    enable = mkEnableOption "Bash";

    defaultShell = mkOption {
      type = types.bool;
      default = false;
      description = "Use bash as default shell";
    };
  };

  config = mkIf cfg.enable rec {
    # TODO: make everything run fine without bash.enable
    # - xdg file
    # - dwm break

    uimaConfig.sh.alias.enable = true;
    uimaConfig.sh-util.fzf.enable = true;

    home.sessionVariables = mkIf cfg.defaultShell {
      SHELL = "bash";
    };

    programs.bash = {
      enable = true;

      historyFile = "${config.xdg.dataHome}/bash_history";
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      historyIgnore = [ "ls" "ll" "a" ];

      bashrcExtra = ''
        source ${fzf-key-bindings}
        source ${fzf-completion}
      '' + builtins.readFile ./bashrc;
    };

    home.file = {
      ".bashrc".enable = false;
      "${config.xdg.configHome}/bash/bashrc".source = config.home.file.".bashrc".source;

      ".profile".enable = false;
      "${config.xdg.configHome}/bash/profile".source = config.home.file.".profile".source;

      ".bash_profile".enable = false;
    };

    home.persistence.main = mkIf imper.enable {
      files = [
        (rmHomePath config.programs.bash.historyFile)
      ];
    };
  };
}
