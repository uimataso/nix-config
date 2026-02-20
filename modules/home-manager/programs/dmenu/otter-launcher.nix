{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.uimaConfig.programs.dmenu.otter-launcher;

  searchEngines = import ../browser/search-engines.nix;

  tomlFormat = pkgs.formats.toml { };
  defaultSettings =
    let
      # we have problem with escape char in toml, see:
      #   https://github.com/NixOS/nixpkgs/issues/267491
      #   https://github.com/NixOS/nixpkgs/issues/97310
      #   https://github.com/nix-community/home-manager/pull/4817
      c = (fromTOML ''c = "\u001B"'').c;
    in
    {
      general = {
        default_module = "se";
        empty_module = "app";

        exec_cmd = "bash -c";
        vi_mode = false;
        esc_to_abort = true;

        cheatsheet_entry = "?";
        cheatsheet_viewer = "less -R; clear";

        clear_screen_after_execution = true;
        loop_mode = false;
        external_editor = config.uimaConfig.programs.editor.executable; # C-x C-e e
        delay_startup = 0;
      };

      interface = {
        header = "";
        header_cmd = "";
        header_cmd_trimmed_lines = 0;
        place_holder = "type";
        suggestion_mode = "list"; # available options: list, hint
        # separator = "────────────────";
        footer = "";
        suggestion_lines = 10;
        list_prefix = "  ";
        selection_prefix = "${c}[31;1m▌ ";
        prefix_padding = 3;
        default_module_message = "  ${c}[33msearch${c}[0m the internet";
        empty_module_message = "";
        customized_list_order = false;
        indicator_with_arg_module = "";
        indicator_no_arg_module = "";

        prefix_color = "${c}[33m";
        description_color = "${c}[39m";
        place_holder_color = "${c}[2;37m";
        hint_color = "${c}[2;37m";

        # move the interface rightward or downward
        move_interface_right = 16;
        move_interface_down = 1;
      };
      modules = [
        {
          description = "app launcher";
          prefix = "app";
          cmd = "app-launcher";
          unbind_proc = true;
        }
        {
          description = "run command in terminal";
          prefix = "s";
          cmd = ''
            setsid -f "$(echo $TERM)" -e {}
          '';
          with_argument = true;
        }
        {
          description = "kill a runing app";
          prefix = "k";
          cmd = ''ps -u "$USER" -o comm= | sort -u | fzf | xargs -r pkill -9'';
        }
      ]
      ++ (lib.attrsets.mapAttrsToList (key: val: {
        description = "search - ${val.name}";
        prefix = "${key}";
        cmd = "xdg-open ${val.url}";
        with_argument = true;
        url_encode = true;
        unbind_proc = true;
      }) searchEngines);
    };
in
{
  options.uimaConfig.programs.dmenu.otter-launcher = {
    enable = mkEnableOption "otter-launcher";

    extraSettings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.otter-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile =
      let
        settings = defaultSettings // cfg.extraSettings;
      in
      {
        "otter-launcher/config.toml".source = tomlFormat.generate "config.toml" settings;
      };
  };
}
