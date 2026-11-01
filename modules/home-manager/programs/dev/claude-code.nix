{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkEnableOption;
  cfg = config.uimaConfig.programs.dev.claude-code;
in
{
  options.uimaConfig.programs.dev.claude-code = {
    enable = mkEnableOption "claude-code";
    langfuse.enable = mkEnableOption "Langfuse tracing for claude-code";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      uimaConfig.system.impermanence = {
        directories = [ ".claude" ];
        files = [ ".claude.json" ];
      };

      programs.claude-code = {
        enable = true;

        # note: they don't follow xdg at all anyway :(
        # configDir = "${config.xdg.configHome}/claude";
      };
    }

    # langfuse-observability plugin: hook runs via `uv run --script`
    # ! claude plugin marketplace add langfuse/Claude-Observability-Plugin
    # ! claude plugin install langfuse-observability@langfuse-observability
    # /plugin configure langfuse-observability@langfuse-observability
    (mkIf cfg.langfuse.enable {
      uimaConfig.system.impermanence.directories = [ ".cache/uv" ];

      programs.claude-code.package = pkgs.symlinkJoin {
        name = "claude-code-langfuse";
        paths = [ pkgs.claude-code ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/claude \
            --prefix PATH : ${lib.makeBinPath [ pkgs.uv ]} \
        '';
      };
    })
  ]);
}
