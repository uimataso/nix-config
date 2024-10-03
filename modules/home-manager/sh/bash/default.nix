{ config
, lib
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.uimaConfig.sh.bash;

  imper = config.uimaConfig.system.impermanence;
  rmHomePath = str: lib.removePrefix config.home.homeDirectory str;

  # Plugins
  # TODO: move these to pkgs
  fzf-key-bindings = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/fzf/v0.54.3/shell/key-bindings.bash";
    sha256 = "12mx1w68m74ld4mh405y0iz2a7575k2xpnd4s9cl7bpwwanv7261";
  };
  fzf-completion = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/lincheney/fzf-tab-completion/11122590127ab62c51dd4bbfd0d432cee30f9984/bash/fzf-bash-completion.sh";
    sha256 = "0d4i2wkki40b9i4mh1cbkd9av93bk9fj3763rhv8wpj5fgg6qwah";
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

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      files = [ (rmHomePath config.programs.bash.historyFile) ];
    };

    uimaConfig.sh = mkIf cfg.defaultShell {
      enable = true;
      executable = "bash";
      tmuxShell = null;
    };

    uimaConfig.programs.sh-util.fzf.enable = true;

    programs.bash = {
      enable = true;

      historyFile = "${config.xdg.dataHome}/bash_history";
      historyControl = [
        "erasedups"
        "ignoredups"
        "ignorespace"
      ];
      historyIgnore = [
        "ls"
        "ll"
        "a"
        "e"
        "e."
        "exit"
      ];

      bashrcExtra =
        # sh
        ''
          # Common Config
          set -o ignoreeof            # Prevent <C-D> to close window
          stty -ixon                  # Disable <C-S> and <C-Q> to stop shell
          shopt -s globstar           # ** support
          shopt -s nocaseglob         # Case-insensitive globbing

          # Readline
          bind 'set completion-ignore-case on'  # Completion case-insensitive
          bind 'set completion-map-case on'     # Treat hypen and underscores as equivalent

          # Prompt
          prompt(){
            _exit_code=$?
            env="$([ -n "''${DIRENV_FILE//}" ] && printf '\[\e[1;37m\]env|')"
            host='\[\e[32m\e[1m\]\h\[\e[0m\]'
            path='\[\e[36m\e[1m\]\w\[\e[0m\]'
            prom="$([ $_exit_code -ne 0 ] && printf '\[\e[31m\]')$\[\e[0m\]"
            PS1="$env$host:$path$prom "
          }
          PROMPT_COMMAND=prompt
          PS2='> '


          # Fzf Shell Integration
          ## C-T: Insert file name
          ## C-R: Search history
          ## A-C: Cd into selected directory
          ## **<Tab>: Fzf's completion
          source ${fzf-key-bindings}


          # Fzf Compltion
          ## Better fzf compltion, just press <Tab>
          source ${fzf-completion}
          bind -x '"\t": fzf_bash_completion'

          # Replace the loading msg and fzf prompt with ''${PS1@P} so the experience is better
          _fzf_bash_completion_loading_msg() { echo "''${PS1@P}''${READLINE_LINE}" | tail -n1; }
          _fzf_bash_completion_selector() {
            FZF_DEFAULT_OPTS="--height ''${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS" \
              $(__fzfcmd 2>/dev/null || echo fzf) -1 -0 --prompt "''${PS1@P}$line" --nth 2 -d "$_FZF_COMPLETION_SEP" --ansi \
              | tr -d "$_FZF_COMPLETION_SEP"
          }
        '';
    };

    home.file = {
      ".bashrc".enable = false;
      ".profile".enable = false;
      ".bash_profile".enable = false;
    };
    xdg.configFile = {
      "bash/bashrc".source = config.home.file.".bashrc".source;
      "bash/profile".source = config.home.file.".profile".source;
    };
  };
}
