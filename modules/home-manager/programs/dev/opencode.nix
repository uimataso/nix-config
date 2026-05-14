{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.programs.dev.opencode;
in
{
  options.uimaConfig.programs.dev.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".local/share/opencode" ];
    };

    programs.opencode = {
      enable = true;

      themes.stylix.theme = {
        background = {
          dark = mkForce "none";
          light = mkForce "none";
        };
      };

      commands = {
        commit = ./opencode/commands/commit.md;
      };

      settings = {
        model = "z-ai/glm-5.1";

        compaction = {
          auto = true;
          prune = true;
          reserved = 32000;
        };
      };

      tui = {
        # TODO: keymap don't works in current version somehow, use deprecated keybinds
        # keymap = {
        #   leader = "ctrl+x";
        #   leader_timeout = 2000;
        #   sections = {
        #     global = {
        #       "app.exit" = "<leader>q"; # no ctrl-c
        #     };
        #     prompt = {
        #       "session.interrupt" = "ctrl+c";
        #       "prompt.clear" = "none";
        #     };
        #     input = {
        #       "input.submit" = "ctrl+return";
        #       "input.newline" = "return,shift+return,alt+return,ctrl+j";
        #     };
        #   };
        # };
        keybinds = {
          app_exit = "<leader>q";
          session_interrupt = "ctrl+c";
          input_clear = "none";
        };
      };
    };
  };
}
