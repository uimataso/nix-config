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

      agents = {
        auto-commit = ./opencode/agents/auto-commit.md;
      };

      settings = {
        model = "opencode-bifrost/code";
        small_model = "opencode-bifrost/fast";

        provider.opencode-bifrost = {
          npm = "@ai-sdk/openai-compatible";
          name = "Bifrost";
          options = {
            baseURL = "https://bifrost.uimataso.com/v1";
            apiKey = "{file:~/.local/share/opencode/.secrets/bifrost-token}";
            headers.x-bf-vk = "{file:~/.local/share/opencode/.secrets/bifrost-token}";
          };
          models = {
            code = {
              name = "code";
              limit = {
                context = 200000;
                output = 32000;
              };
            };
            fast = {
              name = "fast";
              # Thinks by default, which a title does not need.
              options.reasoningEffort = "none";
            };
          };
        };

        compaction = {
          auto = true;
          prune = true;
          reserved = 32000;
        };

        mcp.bifrost = {
          enabled = true;
          type = "remote";
          url = "https://bifrost.uimataso.com/mcp";
          headers.Authorization = "Bearer {file:~/.local/share/opencode/.secrets/bifrost-token}";
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
